/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import "components"

Item {
    id: afterWritingPageExecution

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 20
        anchors.bottomMargin: 35
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
        }
        ColumnLayout {
            id: infoText
            Layout.alignment: Qt.AlignCenter
            spacing: 25

            ImText {
                text: qsTr("<b>%1</b>has been written to<br><b>%2</b><br>for Execution Device").arg(settings.selectedOS).arg(settings.selectedDsc)
                color: "#fff"
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }

            ImText {
                text: "Now you can remove the card and insert another one\nfor Consensus Device"
                color: "#fff"
                font.pointSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }
            Item {
                Layout.alignment: Qt.AlignCenter
                width: 150
                height: 150
                Image {
                    anchors.fill: parent
                    source: "icons/after_writing_execution.png"
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ImButton {
            Layout.minimumHeight: 40
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignCenter
            padding: 5
            text: qsTr("Next")
            onClicked: {
                storagePopup.mode = "consensus"
                storagePopup.open()
            }
        }
    }
}
