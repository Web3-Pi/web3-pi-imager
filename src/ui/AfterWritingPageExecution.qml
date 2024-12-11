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
        anchors.topMargin: 35
        anchors.bottomMargin: 35
        anchors.fill: parent

        ColumnLayout {
            id: infoText
            Layout.alignment: Qt.AlignCenter
            spacing: 45
            Layout.topMargin: 25

            ImText {
                // text: qsTr("Web3 Pi v. 0.7.3 - 64bit (latest) has been written to<br>Apple SDXC Reader Media for Execution Device").arg(settings.selectedOS).arg(settings.selectedDsc)
                text: qsTr("%1 has been written to<br>%2 for Execution Device").arg(settings.selectedOS).arg(settings.selectedDsc)
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                font.weight: Font.Medium
            }

            Item {
                Layout.alignment: Qt.AlignCenter
                width: 275
                height: 176
                Image {
                    anchors.fill: parent
                    source: "icons/after_writing_execution.png"
                    Layout.alignment: Qt.AlignCenter
                }
            }

            ImText {
                text: "Now you can remove the card and insert another one\nfor Consensus Device"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                font.weight: Font.Medium
            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            spacing: 15
            width: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            // ButtonSecondary {
            //     id: quitButton
            //     visible: true
            //     Layout.preferredWidth: 152
            //     Layout.alignment: Qt.AlignCenter
            //     text: qsTr("QUIT")
            //     onClicked: {
            //         Qt.quit()
            //     }
            // }
            // Item {
            //     Layout.fillWidth: false
            // }

            ButtonPrimary {
                Layout.preferredWidth: 187
                Layout.alignment: Qt.AlignCenter
                text: qsTr("NEXT")
                onClicked: {
                    storagePopup.mode = "consensus"
                    storagePopup.open()
                }
            }
        }
    }
}


