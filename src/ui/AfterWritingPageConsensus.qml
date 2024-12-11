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
    id: afterWritingPageConsensus

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 15
        anchors.bottomMargin: 35
        anchors.fill: parent

        ColumnLayout {
            id: infoText
            Layout.alignment: Qt.AlignCenter
            spacing: 10
            Layout.topMargin: 15

            ImText {
                // text: qsTr("<b>Web3 Pi v. 0.7.3 - 64bit (latest)</b> has been written to<br><b>Apple SDXC Reader Media</b> for Execution Device").arg(settings.selectedOS).arg(settings.selectedDsc)
                text: qsTr("<b>%1</b>has been written to<br><b>%2</b> for Consensus Device").arg(settings.selectedOS).arg(settings.selectedDsc)
                Layout.alignment: Qt.AlignCenter
                font.pointSize: 20
                font.weight: Font.Medium
            }

            Item {
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 10
                width: 574
                height: 276
                Image {
                    anchors.fill: parent
                    source: "icons/after_writing_consensus.png"
                    Layout.alignment: Qt.AlignCenter
                }
            }
            ColumnLayout {
                Layout.topMargin: -70
                Layout.leftMargin: -50
                Layout.alignment: Qt.AlignCenter


                ImText {
                    text: "To perform the installations, follow the steps:"
                    font.pointSize: 20
                    font.weight: Font.Medium

                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignCenter
                    spacing: 5

                    ImText {
                        text: "1. Insert first card into Execution Device"
                        font.family: dmsans.name
                        font.pointSize: 18
                        font.italic: true
                    }
                    ImText {
                        text: "2. Insert second card into Consensus Device"
                        font.family: dmsans.name
                        font.pointSize: 18
                        font.italic: true
                    }
                    ImText {
                        text: "3. Connect necessary cables"
                        font.family: dmsans.name
                        font.pointSize: 18
                        font.italic: true
                    }
                    ImText {
                        text: "4. Turn on the devices"
                        font.family: dmsans.name
                        font.pointSize: 18
                        font.italic: true
                    }
                }
            }


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
                    stackView.push(finalPageDualMode)
                }
            }
        }
    }
}


