/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2022 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

ButtonPrimary {
    Material.background: "transparent"
    Material.foreground: Material.foreground
    rippleColor: "#20ffffff"

    Component.onCompleted: {
        background.color = "transparent"
        background.border.color = "#c7ffffff"
        background.border.width = 1
    }
}
