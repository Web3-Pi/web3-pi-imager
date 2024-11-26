/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2022 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

ComboBox {
    Keys.onEnterPressed: toggle()
    Keys.onReturnPressed: toggle()
    font.family: roboto.name
    font.pointSize: 14
    background: Rectangle {
        color: "white"
        radius: 4
        border.color: "#9affffff"
        border.width: 1
    }
}
