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
        anchors.topMargin: 20
        anchors.bottomMargin: 35
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
        }
        ColumnLayout {
            id: infoText
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 25

            ImText {
                text: qsTr("<b>%1</b>has been written to<br><b>%2</b> for Consensus Device").arg(settings.selectedOS).arg(settings.selectedDsc)
                color: "#fff"
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }

            ImText {
                text: "To perform the installation, follow the steps:"
                color: "#fff"
                font.pointSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }

            ColumnLayout {

                ImText {
                    text: "1. Insert the first card into the Executin Device"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                }

                ImText {
                    text: "2. Insert the second card into the Consensus Device"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                }

                ImText {
                    text: "3. Connect the necessary cables"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                }

                ImText {
                    text: "4. Turn on the devices"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                }
            }
            Item {
                Layout.alignment: Qt.AlignCenter
                width: 120
                height: 120
                Image {
                    anchors.fill: parent
                    source: "icons/inserting2.png"
                    Layout.alignment: Qt.AlignCenter
                }
            }
            ImText {
                text: qsTr("The installation process can be monitored at")
                color: "#fff"
                textFormat: Text.RichText
                font.pointSize: 14
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            ColumnLayout {
                ImText {
                    text: qsTr("1. Execution Device: <b><a href='http://%1.local' style='color: white;'>http://%1.local</a></b>").arg(settings.hostnameExecution)
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 14
                    font.italic: true
                }

                ImText {
                    text: qsTr("2. Consesnus Device: <b><a href='http://%1.local' style='color: white;'>http://%1.local</a></b>").arg(settings.hostnameConsesnus)
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 14
                    font.italic: true
                }
            }
            Item {
                Layout.fillHeight: true
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
            text: qsTr("Quit")
            onClicked: {
                Qt.quit()
            }
        }
    }
}
