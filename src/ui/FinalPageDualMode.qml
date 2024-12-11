/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Material.impl
import "components"

Item {
    id: finalPageDualMode
    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 10
        anchors.bottomMargin: 35
        anchors.fill: parent

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 25
            Layout.topMargin: 40

            ColumnLayout {
                id: successInfo
                visible: true
                Layout.alignment: Qt.AlignCenter
                spacing: 40
                Layout.topMargin: 10

                ImText {
                    text: "Thank you for choosing Web3 Pi"
                    font.pointSize: 28
                    font.weight: Font.Medium
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item {
                    width: 82
                    height: 105
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        anchors.fill: parent
                        source: "icons/success.png"
                        Layout.alignment: Qt.AlignCenter
                    }
                }
                ColumnLayout {
                    Layout.alignment: Qt.AlignCenter
                    spacing: 5

                    ImText {
                        text: qsTr("Monitor installation process at: <a href='http://%1.local' style='color: white;'>http://%1.local</a>").arg(settings.hostname)
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pointSize: 18
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                    }

                    ImText {
                        text: qsTr("1. Execution Device: <a href='http://%1.local' style='color: white;'>http://%1.local</a>").arg(settings.hostnameExecution)
                        Layout.leftMargin: 5
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pointSize: 18
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                    }

                    ImText {
                        text: qsTr("2. Consensus Device: <a href='http://%1.local' style='color: white;'>http://%1.local</a>").arg(settings.hostnameConsensus)
                        textFormat: Text.RichText
                        Layout.leftMargin: 5
                        color: "#99ffffff"
                        font.pointSize: 18
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                    }

                    ImText {
                        text: qsTr("More information at: <a href='https://www.web3pi.io' style='color: white;'>www.web3pi.io</a>")
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pointSize: 18
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 20


            ButtonPrimary {
                id: finishButton
                visible: true
                Layout.preferredWidth: 187
                Layout.alignment: Qt.AlignCenter
                text: qsTr("FINISH")
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }
}

