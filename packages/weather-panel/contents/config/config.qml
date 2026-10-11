import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Weather")
        icon: "weather-clear"
        source: "config/ConfigGeneral.qml"
    }
    ConfigCategory {
        name: i18n("More & Support")
        icon: Qt.resolvedUrl("../ui/icons/about/bmc-icon.svg")
        source: "config/ConfigAbout.qml"
    }
}
