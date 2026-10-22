#!/usr/bin/env bash

# build.sh - Compile .po translations into .mo files inside each package
#
# Compiles every translate/<package>/*.po into a binary .mo placed where Plasma
# looks for it, so the translation ships with the widget on install/package.
#
# Usage:
#   ./translate/build.sh              # all widgets with translation sources
#   ./translate/build.sh weather      # a single package
#
# Requires gettext (msgfmt):
#   Debian/Ubuntu: sudo apt install gettext
#   Fedora:        sudo dnf install gettext
#   Arch:          sudo pacman -S gettext

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v msgfmt >/dev/null 2>&1; then
    echo "[!] msgfmt not found. Install gettext:"
    echo "    Debian/Ubuntu: sudo apt install gettext"
    echo "    Fedora:        sudo dnf install gettext"
    echo "    Arch:          sudo pacman -S gettext"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "[!] jq not found. Install jq to read widget metadata.json files." >&2
    exit 1
fi

build_package() {
    local PACKAGE_NAME="$1"

    local PACKAGE_DIR="${PROJECT_DIR}/packages/${PACKAGE_NAME}"
    local METADATA_FILE="${PACKAGE_DIR}/metadata.json"
    local PO_DIR="${SCRIPT_DIR}/${PACKAGE_NAME}"

    [[ -f "$METADATA_FILE" ]] || { echo "[!] No metadata.json for: ${PACKAGE_NAME}" >&2; return 1; }
    [[ -d "$PO_DIR" ]] || return 0

    local PLUGIN_ID
    if ! PLUGIN_ID=$(jq -er '.KPlugin.Id | select(type == "string" and length > 0)' "$METADATA_FILE"); then
        echo "[!] Invalid or missing KPlugin.Id in: ${METADATA_FILE}" >&2
        return 1
    fi
    local DOMAIN="plasma_applet_${PLUGIN_ID}"

    local LANG_COUNT=0
    for PO_FILE in "${PO_DIR}"/*.po; do
        [[ -f "$PO_FILE" ]] || continue

        local LANG_CODE
        LANG_CODE=$(basename "$PO_FILE" .po)
        local LOCALE_DIR="${PACKAGE_DIR}/contents/locale/${LANG_CODE}/LC_MESSAGES"
        local MO_FILE="${LOCALE_DIR}/${DOMAIN}.mo"

        mkdir -p "$LOCALE_DIR"
        msgfmt --check --output-file="$MO_FILE" "$PO_FILE"

        echo "    [+] ${PACKAGE_NAME}/${LANG_CODE} -> ${DOMAIN}.mo"
        LANG_COUNT=$((LANG_COUNT + 1))
    done

    if [[ $LANG_COUNT -eq 0 ]]; then
        echo "[*] ${PACKAGE_NAME}: no .po files yet"
    fi

    return 0
}

echo "macOS Widgets - compiling translations"
echo ""

if [[ $# -gt 1 ]]; then
    echo "Usage: $0 [widget]" >&2
    exit 2
fi

if [[ $# -eq 1 ]]; then
    if [[ ! -d "${PROJECT_DIR}/packages/$1" ]]; then
        echo "[!] Package not found: $1" >&2
        exit 1
    fi
    build_package "$1"
else
    for PACKAGE_DIR in "${PROJECT_DIR}"/packages/*/; do
        build_package "$(basename "$PACKAGE_DIR")"
    done
fi

echo ""
echo "[+] Done. Run ./install.sh to update installed widgets."
