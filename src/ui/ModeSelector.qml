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
            Layout.topMargin: 80
            Layout.bottomMargin: 80
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            spacing: 40
            ColumnLayout {
                spacing: 20
                anchors.top: parent.top
                Rectangle {
                    height: 120
                    width: 170
                    Layout.bottomMargin: 10
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Image {
                        source: "./icons/mode_single.png"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    }
                }

                ButtonPrimary {
                    text: qsTr("Single Mode Device")
                    font.weight: Font.Bold
                    font.pointSize: 22
                    Layout.preferredWidth: 248
                    Layout.preferredHeight: 55
                    onClicked: {
                        settings.mode = "single"
                        stackView.push(singleModeForm)
                    }
                }

                ImText {
                    text: "Raspberry Pi 5 (8GB) min."
                    font.pointSize: 20
                    font.weight: Font.Medium
                }

                ImText {
                    text: "Execution and Consensus\nEthereum layers, with\nintegrated monitoring tools\non a single device."
                    font.family: dmsans.name
                    font.italic: true
                    font.pointSize: 16
                }

            }
            ColumnLayout {
                spacing: 20
                anchors.top: parent.top
                Rectangle {
                    height: 120
                    width: 170
                    Layout.bottomMargin: 10
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Image {
                        source: "./icons/mode_dual.png"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    }
                }

                ButtonSecondary {
                    text: qsTr("Dual Mode Device")
                    font.weight: Font.Bold
                    font.pointSize: 22
                    Layout.preferredWidth: 248
                    Layout.preferredHeight: 55
                    onClicked: {
                        settings.mode = "execution"
                        stackView.push(dualModeForm)
                    }
                }

                ImText {
                    text: "2x Raspberry Pi 4 (8GB) min."
                    font.pointSize: 20
                    font.weight: Font.Medium
                }

                ImText {
                    text: "Two sets of devices are required.\n- Consensus layer (~500GB storage)\n- Execution layer (2TB storage)"
                    font.family: dmsans.name
                    font.italic: true
                    font.pointSize: 16
                }
            }
        }
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            TextInfo {
                text: "For more information head to <a href='http://www.web3pi.io' style='color: \"#249EC7\"'>www.web3pi.io</a>"
                textFormat: Text.RichText
                onLinkActivated: (link) => Qt.openUrlExternally(link)
            }
        }
    }

}




