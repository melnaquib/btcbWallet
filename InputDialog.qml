import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Dialog {
    id: msgBox
    property alias content: content

    anchors.centerIn: parent

//    property alias title: title.text
    property alias msg: msg.text
    property alias icon: msg.text

    property alias value: input.text

    property string mode

    readonly property string mode_error: "error"
    readonly property string mode_information: "information"
    readonly property string mode_warning: "warning"
    readonly property string mode_password: "password"
    readonly property string mode_question: "question"

    Page {
//        header: Label {
//            id: title
//        }

        GridLayout {
            id: content
            anchors.fill: parent
            columns: 1
            Label {
                id: msg
            }

            TextField {
                id: input
                placeholderText: title
                Layout.fillWidth: true
            }

        }

    }

    standardButtons: Dialog.Ok | Dialog.Cancel

    function show(amode, atitle, amsg) {
        msgBox.mode = mode_question;
        msgBox.title = atitle;
        msgBox.msg = amsg;
        open();
    }
}
