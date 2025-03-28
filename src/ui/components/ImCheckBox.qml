/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2022 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

CheckBox {
    Keys.onEnterPressed: toggle()
    Keys.onReturnPressed: toggle()
    font.family: outfit.name
    font.pixelSize: 18
    padding: 0
    Material.foreground: Material.theme === Material.Dark ? "#fff" : "#222"
}
