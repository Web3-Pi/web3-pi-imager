import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

TextField {
    font.family: outfit.name
    font.letterSpacing: 1
    font.pointSize: 16
    padding: 0
    implicitHeight: 42
    Layout.fillWidth: true
    Material.foreground: "#222"
    font.weight: Font.Medium
    background: Rectangle {
        color: "white"
        radius: 9
        border.width: Material.theme === Material.Dark ? 0 : 1
        border.color: enabled ? Material.foreground : "#aaa"
    }
}
