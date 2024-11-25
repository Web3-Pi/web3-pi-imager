import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

TextField {
    font.family: roboto.name
    font.pointSize: 14
    padding: 0
    implicitHeight: 35
    background: Rectangle {
        color: "white"
        radius: 4
        border.color: "#9affffff"
        border.width: 1
    }
}
