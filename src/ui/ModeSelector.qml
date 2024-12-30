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
    id: modeSelector

    ColumnLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        RowLayout {
            Layout.topMargin: 90
            Layout.bottomMargin: 60
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            spacing: 40
            ColumnLayout {
                spacing: 25
                Layout.alignment: Qt.AlignTop
                Rectangle {
                    id: rectangle
                    height: 120
                    width: 170
                    Layout.bottomMargin: 10
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Image {
                        source: "./icons/mode_single.png"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                ButtonPrimary {
                    id: buttonSingle
                    text: qsTr("Single Mode Device")
                    font.family: outfitBold.name
                    font.weight: Font.Bold
                    font.pixelSize: 24
                    Layout.preferredWidth: 248
                    Layout.preferredHeight: 47
                    onClicked: {
                        settings.mode = "single"
                        stackView.push(singleModeForm)
                    }
                    Material.background: buttonSingle.hovered ? "#E51763" : "#FFFFFF"
                    Material.foreground: buttonSingle.hovered ? "#FFFFFF" : Material.accent
                    rippleColor: Material.accent
                }

                ImText {
                    text: "Raspberry Pi 5 (8GB) min."
                    font.pixelSize: 20
                    font.weight: Font.Medium
                }

                ImText {
                    text: "Execution and Consensus\nEthereum layers, with\nintegrated monitoring tools\non a single device."
                    font.family: dmsansItalic.name
                    font.italic: true
                    font.pixelSize: 16
                }

            }
            ColumnLayout {
                spacing: 25
                Layout.alignment: Qt.AlignTop
                Rectangle {
                    id: rectangle1
                    height: 120
                    width: 170
                    Layout.bottomMargin: 10
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Image {
                        anchors.top: parent.top
                        anchors.topMargin: -15
                        source: "./icons/mode_dual.png"
                        // anchors.horizontalCenter: parent.horizontalCenter
                       Layout.alignment: Qt.AlignHCenter
                    }
                }

                ButtonPrimary {
                    id: buttonDual
                    text: qsTr("Dual Mode Device")
                    font.family: outfitBold.name
                    font.weight: Font.Bold
                    font.pixelSize: 24
                    Layout.preferredWidth: 248
                    Layout.preferredHeight: 47
                    onClicked: {
                        settings.mode = "execution"
                        stackView.push(dualModeForm)
                    }
                    Material.background: buttonDual.hovered ? "#E51763" : "#FFFFFF"
                    Material.foreground: buttonDual.hovered ? "#FFFFFF" : Material.accent
                    rippleColor: Material.accent
                }

                ImText {
                    text: "2x Raspberry Pi 4 (8GB) min."
                    font.pixelSize: 20
                    font.weight: Font.Medium
                }

                ImText {
                    text: "Two sets of devices are required.\n- Consensus layer (~500GB storage)\n- Execution layer (2TB storage)"
                    font.family: dmsansItalic.name
                    font.italic: true
                    font.pixelSize: 16
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            TextInfo {
                text: "For more information head to"
            }
            TextInfo {
                text: "<a href='https://www.web3pi.io/' style='color: \"#249EC7\";'>www.web3pi.io</a>"
                textFormat: Text.RichText
                onLinkActivated: (link) => Qt.openUrlExternally(link)
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: false
                }
            }
        }
    }

}




