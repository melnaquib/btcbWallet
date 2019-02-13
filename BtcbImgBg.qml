import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Universal 2.3

Item {
    property bool themeLight: Universal.theme == Universal.Light

    Image {
        id: bg
        source: themeLight ? "": "images/bg.png"
        anchors.fill: parent

    }

    BrightnessContrast {
        anchors.fill: bg
        source: bg
        brightness: -0.8
//            contrast: 0.9
    }
}
