import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Universal 2.3

Item {
    id: logo

    property bool themeLight: Universal.theme == Universal.Light

    height: parent.height / 4
    width: height

    z: 10

//    anchors.fill: parent
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top

    property bool locked : true
    state: locked ? "" : "unlocked"
    onLockedChanged: glowAnim.start()


    states: [
        State {
            name: "unlocked"
            PropertyChanges {
                target: logo;
                height: parent / 4
            }
            PropertyChanges {
                target: logo;
                scale: .4
            }
            AnchorChanges {
                target: logo;
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: undefined
                anchors.horizontalCenter: undefined
            }
        }
    ]

    transitions: Transition {
        // smoothly reanchor myRect and move into new position
        AnchorAnimation {
            duration: 2000
            easing.type: Easing.OutQuart
        }
    }

    scale: 1
    Behavior on scale {

        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }



    Image {
        id: bg
        source: themeLight ? "": "images/icons/logo.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent

    }

    Glow {
        id: glow
        anchors.fill: bg
        source: bg
        color: Universal.foreground
        radius: 10

        Behavior on radius {

            NumberAnimation {
                duration: 2000
                easing {
                    type: Easing.OutQuart
                    overshoot: 50
                }
            }
        }

//            contrast: 0.9
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
//            glow.radius = 50;
//            scale = 1;
//            logo.locked = !logo.locked;
        }
    }

    SequentialAnimation {
        id: glowAnim

        NumberAnimation {
            target: glow
            property: "radius"
            duration: 1000
            easing.type: Easing.OutQuad
            to: 100
        }
        NumberAnimation {
            target: glow
            property: "radius"
            duration: 1000
            easing.type: Easing.OutQuad
            to: 10
        }
    }
}
