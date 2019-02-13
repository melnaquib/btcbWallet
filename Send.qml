import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import "util.js" as Util
import "rpc.js" as Rpc


Page {
    id: sendPage

    property string wallet
    property bool newWallet: !Util.isStrNotEmpty(wallet)
    property string accountCreated;

    background: Item{}

    property string sender

    title: qsTr("Send From ") + sender

    header: Label {
        text: qsTr("Send From ") + sender
    }

    GridLayout {
//        anchors.fill: parent
        anchors.bottom: parent.bottom
        width: parent.width
        anchors.margins: 10

        columns: 1

//        Button {
//            text: "create Account"
//            onClicked:{
//               accountCreated =  Rpc.createAccount(wallet);
//                console.log(accountCreated)
//            }
//        }
//        Button {
//            text: "Account Representative"
//            onClicked: {
//                var res = Rpc.accountRepresentative(accountCreated);
//                console.log(res);
//              }
//        }


        Label {text: qsTr("Receiver")}

        ComboBox {
            id: recv
            editable: true
            Layout.fillWidth: true
            validator: ValidatorAddress{}
        }

        Label {text: qsTr("Amount")}

        SpinBox {
            id: amount
            Layout.fillWidth: true
        }
    }

    footer: DialogButtonBox {
        standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel

        onAccepted: {
            var ok = Rpc.send(recv.currentText, amount.value);
            if(ok) {
                msg.show(msg.mode_information, qsTr("Send Successful!"), qsTr("Send successful!"));
                back();
            } else {
                msg.show(msg.mode_warning, qsTr("Send Failed!"), qsTr("Send Failed!"));
            }
        }

        onRejected: {
            amount.value = 0;
            recv.currentText = "";
            back();
        }
    }

    signal back()


    function onNewWallet(passwd, passwd_confirm, seed) {
        if(passwd != passwd_confirm) {
            msg.show(msg.mode_password, "Password mismatch!", "Password mismatch!");
            return;
        }

        var w = Rpc.newWallet();
        var passwd;
    }

    function onLogin(passwd) {

    }

    MessageBox {
        id: msg
    }

}
