import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Universal 2.3


ApplicationWindow {
    id: mainWin

    visible: true
    width: 800
    height: 600
    title: qsTr("Tabs")

    background: BtcbImgBg{}
    property int margin: 20

    property alias light: lightCb.checked
    Universal.theme: light ? Universal.Light : Universal.Dark
    Universal.foreground : light ? "cyan" : "gold"
    Universal.accent: Universal.foreground

    property string wallet

    Logo{
        id: logo
        locked: 0 == mainView.currentIndex
    }

    SwipeView {
        id: mainView
        anchors.fill: parent
//        anchors.margins: margin
        padding: margin
        currentIndex: 0
//        interactive: false

        Login {
            id: login
            padding: margin
            onLoginSuccess: {
                mainView.setCurrentIndex(1);
                mainWin.wallet = wallet;
            }
        }

        AccountPage {
            id: accountPage
            wallet: mainWin.wallet
            onSend: {
                sendPage.sender = account;
                mainView.currentIndex = 2;
            }
        }

        Send {
            id: sendPage
            padding: margin
        }
    }

    CheckBox {
        id: lightCb
        anchors.top: parent.top
        anchors.right: parent.right
        text: checked ? qsTr("Light") : qsTr("Dark")
    }
}
