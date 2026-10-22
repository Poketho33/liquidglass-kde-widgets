import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: root
    spacing: Kirigami.Units.largeSpacing

    property alias cfg_use24Hour: use24HourCheck.checked
    property alias cfg_smoothSeconds: smoothSecondsCheck.checked

    Kirigami.FormLayout {
        Layout.fillWidth: true

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Clock")
        }

        CheckBox {
            id: use24HourCheck
            Kirigami.FormData.label: i18n("24-hour clock:")
            text: i18n("Show hours from 00 to 23")
        }

        CheckBox {
            id: smoothSecondsCheck
            Kirigami.FormData.label: i18n("Smooth seconds:")
            text: i18n("Animate the second sweep continuously")
        }

        Label {
            visible: smoothSecondsCheck.checked
            text: i18n("Smooth seconds redraws at approximately 60 FPS and may increase CPU/GPU usage.")
            wrapMode: Text.WordWrap
            opacity: 0.75
            Layout.fillWidth: true
        }
    }
}
