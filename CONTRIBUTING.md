# Contributing

Thanks for wanting to help. This project is a set of **macOS Tahoe / iOS-style widgets for KDE
Plasma 6**, all sharing one liquid-glass look. There are several ways to help, and most of them
don't need code.

| I want to… | Do this |
|---|---|
| Report a bug | Open a [bug report](https://github.com/jaxparrow07/liquidglass-kde-widgets/issues/new?template=bug_report.md) |
| Suggest a new widget | [Open a widget request](#suggesting-a-widget) (no coding needed) |
| Suggest a change to an existing widget | Open a [change request](https://github.com/jaxparrow07/liquidglass-kde-widgets/issues/new?template=changes-additions-to-existing-widget.md) |
| Add or fix a translation | See the [Translation Guide](translate/TRANSLATE.md) |
| Fix a bug or add an option | Open a pull request (see [Pull requests](#pull-requests)) |
| Build a new widget | Read [Building a new widget](#building-a-new-widget) **first** |

## Suggesting a widget

Anyone can suggest a widget, and you don't need to be a developer. Open a
[New widget request](https://github.com/jaxparrow07/liquidglass-kde-widgets/issues/new?template=new-widget-request.md)
with:

- the macOS or iOS widget (or system feature) it's like. A screenshot or a link is enough
- why it would be useful alongside the other widgets here

Everything else in the form is optional.

## Building a new widget

This repository is a **curated set of macOS-style widgets**, not a general widget collection.
**Unrelated widgets cannot be merged**, however well they're built.

1. **Open a widget request issue first, before writing code.** Include the macOS / iOS reference,
   how the widget follows the [Design Guidelines](DESIGN.md), and why it belongs in this repo
   rather than as a standalone widget.
2. **Wait for it to be accepted.** Pull requests that add an unrequested widget will be closed.
3. **If your widget is unrelated to macOS, or looks completely different from it,** please make it
   your own separate widget. You're welcome to use the liquid-glass shader
   (`1-common/components/LiquidGlass.qml` and `shaders/`) in it under the GPL v3, with attribution.

Fixes, new options and translations for **existing** widgets don't need a request issue.

## Setting up

You need Plasma 6.x and Qt 6.x. The scripts use these tools (package names vary by distro; see the
README's [prerequisites](README.md#prerequisites)):

- `kpackagetool6`, `jq` and `zip`: installing and packaging
- `qsb`: rebuilding shaders, only if you edit a `.frag` file
- `plasmoidviewer`: quick previews, optional
- `gettext` (`msgfmt`, `xgettext`, `msgmerge`): translations, also needed by `install.sh` and
  `package.sh`

```bash
./install.sh <name>        # install or update one widget (restarts plasmashell)
./install.sh --all         # install every widget in packages/
./test.reload.sh <name>    # open a widget in plasmoidviewer (no plasmashell restart)
./build-shaders.sh         # recompile 1-common/components/shaders/*.frag -> *.qsb
./package.sh <name>        # build a .plasmoid into 2-packaged/
```

Compiled `.qsb` shaders are committed. Run `./build-shaders.sh` only after changing a `.frag` file,
and commit the rebuilt `.qsb` with it.

`plasmoidviewer` has no real wallpaper, so the glass falls back to a flat tinted rectangle there.
**Check anything visual on your real desktop with `./install.sh`.**

## How the repository is laid out

- `packages/<name>/` is one widget, a standalone Plasma applet.
- `1-common/` holds what every widget shares: `LiquidGlass.qml`, `MacOSColors.qml`, the shaders,
  fonts, icons and the Appearance settings page.
- **Shared files are symlinked into each package, never copied.** Edit the file in `1-common/`
  and every widget picks it up. Please don't add a per-package copy of a shared file; add a hook
  instead.
- `translate/` holds the translation templates and `.po` files.

[AGENTS.md](AGENTS.md) is written for AI coding agents but is also the most detailed description of
how the code fits together (the glass pipeline, settings pages, panel and wide layouts).

## Pull requests

Keep each pull request to **one focused change**, and describe what you changed and why. The
history uses short summaries like `feat(music): …` and `fix(liquidglass): …`.

When you open a pull request, its template asks you to confirm a short checklist: tested on a real
desktop, the [Design Guidelines](DESIGN.md) followed for anything visual, strings translatable, and
shared files still symlinked. The sections above and below explain each of these.

Settings live in three files that must agree entry by entry: `contents/config/main.xml`,
`contents/config/config.qml` and the settings page itself.

## Translations

Every user-visible string is translatable. To add or update a language, follow the
[Translation Guide](translate/TRANSLATE.md). You only need to send the `.po` file; the compiled
catalogs are generated at install time and aren't committed.

## License

Contributions are licensed under the project's **GNU GPL v3**, see [LICENSE](LICENSE). The bundled
fonts and icons come from Apple's design system and are **not** covered by it (see the README).
Please don't add fonts, icons or images you don't have the right to redistribute, and ask first if
you're unsure.
