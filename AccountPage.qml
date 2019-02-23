import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Universal 2.3

import "rpc.js" as Rpc


Page {

    id: accountPage

    property string wallet
    property var accs: walletAccounts(wallet)
    property alias account: accountsComboBox.currentText

    background: Item{}

    header: RowLayout {
        ToolButton {
            icon.name: "document-new"
            icon.source: "images/icons/add_account.png"
            onClicked: {
                var newAcc = Rpc.createNextAccount(wallet);
                msg.show(msg.mode_information, qsTr("Account Created"), qsTr("New account has been created;\n%1").arg(newAcc))
                accountsComboBox.model = Rpc.walletAccounts(wallet);
            }
        }

        ComboBox {
            id: accountsComboBox
            Layout.fillWidth: true
            editable: false
            textRole: "account"
            model: Rpc.walletAccounts(wallet);
        }

        ToolButton {
            icon.name: "edit-copy"
            icon.source: "images/icons/edit_copy.png"
            onClicked: {
                proxy.toClipboard(accountsComboBox.currentText);
                msg.show(msg.mode_information, qsTr("Address Copied!"), qsTr("Current account address has been copied to clipboard."))
            }
        }

        ToolButton {
            icon.name: "network-transmit-receive"
            text: qsTr("New Representative")
            onClicked: {
                var repr = Rpc.accountRepresentative(account);
                console.log(repr);
                reprDlg.show(msg.mode_information, qsTr("Representative"),
                             qsTr("Please set representative for account\n%1\nCurrent Representative;\n%2").arg(account).arg(repr));
                
            }
        }

        ToolButton {
            text: qsTr("Send")
            icon.source: "images/icons/send.png"
            onClicked: send(account)
        }
    }

    signal send(string acount)


    TxsList {
        id: txLV
        anchors.fill: parent
        account: accountPage.account
        balance: accountsComboBox.model[accountsComboBox.currentIndex].balance
    }

    function walletAccounts(w) {
        Rpc.walletAccounts(w);
    }

    MessageBox { id: msg }

    InputDialog {
        id: reprDlg
        onAccepted :{
            console.log(value);
        }
    }
}
