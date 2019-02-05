import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import "util.js" as Util
import "rpc.js" as Rpc


Dialog {

    modal: true

    standardButtons: Dialog.Ok

    Login {
        id: login
    }

    onAccepted: { if(!login.accpet()) open(); }
}
