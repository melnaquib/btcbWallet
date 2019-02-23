import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Universal 2.3

import "accs.js" as Accs
import "rpc.js" as Rpc
import "fmt.js" as Fmt

ListView {
    id: txsList

    property var txs: []
    property string account: ""
    onAccountChanged: reload()

    property string balance

    anchors.margins: 10
    spacing: 5

    function getTxDescr(receive, bind) {
        return receive ? (bind ? "Receiving" : "Received") : (bind ? "Sending" : "Sent")
    }

    header: Label {
        id: balanceLabel
        text: qsTr("Balance ") + Fmt.fmt(txsList.balance)
        padding: 20
    }

    delegate: RowLayout {
        id: txRow
        property var tx: index < txs.length ? txs[index] : {type: "", binding: "", date: "", binding: ""}

        property bool receive: "receive" == tx.type

        Rectangle {
            width: height
            height: txSymbolTxt.height
            radius: height / 2
            color: receive ? "lightBlue" : "white"
            Text {
                id: txSymbolTxt
                anchors.centerIn: parent
                text: receive ? "+" : "-"
                font.bold: true
                opacity:  tx.binding ? 0.5 : 1.0
            }
        }

        Label {
            text: tx.date
            color: Universal.foreground
        }
        Label {
            text: txsList.getTxDescr(receive, tx["binding"])
            color: "white"
        }
        Label {
            text: Fmt.fmt(tx["amount"])
            color: Universal.foreground
        }
        Label {
            text: tx["account"]
            color: Universal.foreground
            Layout.fillWidth: true
        }
    }

    Timer {
        repeat: true
        running: parent.visible
        interval: 60 * 1000
        onTriggered: reload()
    }

    function reload() {
        txs = Rpc.account_history(account);
        txsList.model = txs.length;
    }
}
