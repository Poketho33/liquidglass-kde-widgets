import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-theme"
        source: "config/ConfigAppearance.qml"
    }
    ConfigCategory {
        name: i18n("Filter")
        icon: "view-filter"
        source: "config/ConfigFilter.qml"
    }
    ConfigCategory {
        name: i18n("Lyrics")
        icon: "preferences-desktop-font"
        source: "config/ConfigLyrics.qml"
    }
    ConfigCategory {
        name: i18n("More & Support")
        icon: Qt.resolvedUrl("../ui/icons/about/bmc-icon.svg")
        source: "config/ConfigAbout.qml"
    }
}
