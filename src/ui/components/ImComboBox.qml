/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2022 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

ComboBox {
    id: control
    font.letterSpacing: 1
    Keys.onEnterPressed: toggle()
    Keys.onReturnPressed: toggle()
    font.family: outfit.name
    font.pointSize: 16
    implicitHeight: 42
    font.weight: Font.Medium
    Component.onCompleted: {
        popup.background.color = "#FFF"
        popup.background.radius = 9
    }
    Material.foreground: "#000"
    background: Rectangle {
        color: "#FFF"
        radius: 9
        border.color: enabled ? Material.foreground : "#aaa"
    }
    hoverEnabled: true

    delegate: MenuItem {
        required property var model
        required property int index

        width: ListView.view.width
        text: model[control.textRole]
        Material.foreground: hovered ? Material.accent : "#000"
        background: Rectangle {
            color: hovered ? "#10000000" : "transparent"
        }
        font.letterSpacing: 1
        font.family: outfit.name
        font.pointSize: 16

        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }
}
