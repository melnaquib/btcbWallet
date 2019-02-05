import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Popup {
    id: msgBox

    anchors.centerIn: parent

    property alias title: title.text
    property alias msg: msg.text
    property alias icon: msg.text

    property string mode

    readonly property string mode_error: "error"
    readonly property string mode_information: "information"
    readonly property string mode_warning: "warning"
    readonly property string mode_password: "password"
    readonly property string mode_question: "question"

    Page {
        header: Label {
            id: title
        }

        Button {
            id: msg
            flat: true
            onClicked: msgBox.close()
            icon.name: "dialog-" + mode
        }

    }

    function show(amode, atitle, amsg) {
        msgBox.mode = amode;
        msgBox.title = atitle;
        msgBox.msg = amsg;
        open();
    }
}
