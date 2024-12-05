import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

ImComboBox {
    id: fieldNetwork
    model: ListModel {
        ListElement { text: "Ethereum Mainnet"; value: "mainnet" }
        ListElement { text: "Ethereum Sepolia"; value: "sepolia" }
        ListElement { text: "Ethereum Holesky"; value: "holesky" }
    }
    currentIndex: 0
    textRole: "text"
    selectTextByMouse: true
    Layout.minimumWidth: 245
    Layout.minimumHeight: 35
    font.pointSize: 12
}