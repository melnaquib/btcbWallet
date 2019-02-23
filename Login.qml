import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import "util.js" as Util
import "rpc.js" as Rpc


Page {
    id: login

    property string wallet: "083E6F2F7DFC6A9F2348C30881CDCB91FA8A779FA100E864F05B3EE472FA861A"
    property bool newWallet: newWalletBtn.checked
//    property bool newWallet: true

    background: Item{}

    signal loginSuccess(string wallet)

    GridLayout {
//        anchors.fill: parent
        anchors.bottom: parent.bottom
        width: parent.width
        anchors.margins: 10

        columns: 2

        TextField {
            id: passwd
            Layout.fillWidth: true
            echoMode: TextField.PasswordEchoOnEdit
            placeholderText: qsTr("Password")
            Layout.columnSpan: 2
        }

        TextField {
            id: passwd_confirm
            Layout.fillWidth: true
            echoMode: TextField.PasswordEchoOnEdit
            visible: login.newWallet
            placeholderText: qsTr("Confirm Password")
//            visible: newWallet
            Layout.columnSpan: 2
        }

        TextField {
            id: seed
            Layout.fillWidth: true
            placeholderText: qsTr("Seed")
            visible: login.newWallet
//            echoMode: TextField.PasswordEchoOnEdit
            validator: RegExpValidator { regExp: /[0-9A-Fa-f]+/ }
//            visible: newWallet
        }

        Button {
            text: qsTr("Generate Random Seed")
            visible: login.newWallet
                onClicked: {
                seed.text = "0000000000000000000000000000000000000000000000000000000000000000"
            }
        }

    }

    footer: RowLayout {
        width: parent.width
        Button {
            text: qsTr(newWallet ? "Restore Seed" : " Unlock Wallet")
            onClicked: newWallet ? onNewWallet(passwd.text, passwd_confirm.text, seed.text) : onLogin(passwd.text)
            Layout.fillWidth: true
        }

        Button{
            id: newWalletBtn
            text: qsTr(checked ? "Cancel" : "New Wallet ...")
            checkable: true
            Layout.fillWidth: true
        }
    }

    function onNewWallet(apasswd, apasswd_confirm, aseed) {
        if(apasswd != apasswd_confirm) {
            msg.show(msg.mode_password, "Password mismatch!", "Password mismatch!");
            return;
        }
        if(!Util.isStrNotEmpty(aseed)) {
            msg.show(msg.mode_password, "Invalid Seed!", "Please Provide a seed that is\nHexadecimal\nOf length 32\n Sufficiently random!");
            return;
        }

        var w = Rpc.newWallet(aseed, apasswd);
        if(Util.isStrNotEmpty(w)) {
            wallet = w;
            loginSuccess(wallet);
        } else {
            msg.show(msg.mode_error, qsTr("Wallet Not Created!"), qsTr("Wallet Not Created!"));
        }
    }

    function onLogin(passwd) {
        var ok = Rpc.unlockWallet(wallet, passwd);
        if(ok) {
            loginSuccess(wallet);
        } else {
            msg.show(msg.mode_error, qsTr("Incorrect Password!"), qsTr("Cannot unlock wallet \n%1").arg(wallet));
        }

    }

    Settings {
//        property alias wallet: login.wallet
    }

    Component.onCompleted: {
        console.log("W " + wallet);
        console.log("W " + newWallet);
    }

    MessageBox { id: msg }
}
