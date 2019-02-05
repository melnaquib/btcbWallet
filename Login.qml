import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import "util.js" as Util
import "rpc.js" as Rpc


Page {
    id: login

    property string wallet
    property bool newWallet: !Util.isStrNotEmpty(wallet)
//    property bool newWallet: true

    background: Item{}

    signal loginSuccess(string wallet)

    GridLayout {
//        anchors.fill: parent
        anchors.bottom: parent.bottom
        width: parent.width
        anchors.margins: 10

        columns: 1

        TextField {
            id: passwd
            Layout.fillWidth: true
            echoMode: TextField.PasswordEchoOnEdit
            placeholderText: qsTr("Password")
        }

        TextField {
            id: passwd_confirm
            Layout.fillWidth: true
            echoMode: TextField.PasswordEchoOnEdit
            placeholderText: qsTr("Confirm Password")
        }

        TextField {
            id: seed
            Layout.fillWidth: true
            placeholderText: qsTr("Seed")
//            echoMode: TextField.PasswordEchoOnEdit
            validator: RegExpValidator { regExp: /[0-9A-Fa-f]+/ }
        }

    }

    footer: Button {
        text: qsTr(newWallet ? "Restore Seed" : " Unlock Wallet")
        onClicked: newWallet ? onNewWallet(passwd.text, passwd_confirm.text, seed.text) : onLogin(passwd.text)
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
        property alias wallet: login.wallet
    }

    MessageBox { id: msg }
}
