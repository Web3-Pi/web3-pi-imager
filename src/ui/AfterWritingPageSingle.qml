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
    id: afterWritingPageSingle
    anchors.fill: parent

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 0
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
                // text: qsTr("Web3 Pi v. 0.7.3 - 64bit (latest) has been written to<br>Apple SDXC Reader Media for Execution Device").arg(settings.selectedOS).arg(settings.selectedDsc)
                text: qsTr("%1 has been written to<br>%2").arg(settings.selectedOS).arg(settings.selectedDsc)
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                font.weight: Font.Medium
            }
            Item {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 349
                height: 176
                Layout.fillWidth: false
                Image {
                    anchors.fill: parent
                    source: "icons/inserting.png"
                    Layout.alignment: Qt.AlignCenter
                }
            }

            ImText {
                text: "To install it now, perform following operations:"
                font.pixelSize: 20
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                ImText {
                    text: "1. Insert the card into the Raspberry Pi"
                    font.family: dmsans.name
                    font.pixelSize: 18
                    font.italic: true
                }

                ImText {
                    text: "2. Connect the necessary cables"
                    font.family: dmsans.name
                    font.pixelSize: 18
                    font.italic: true
                }

                ImText {
                    text: "3. Turn on the device"
                    font.family: dmsans.name
                    font.pixelSize: 18
                    font.italic: true
                }
            }

            // TODO: ???
            ImText {
                text: qsTr("If you want to install later,<br>the installation process can be monitored at <b><a href='http://%1.local' style='color: white;'>http://%1.local</a></b>").arg(settings.hostname)
                textFormat: Text.RichText
                font.pixelSize: 15
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
                visible: false
            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            spacing: 15
            width: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ButtonSecondary {
                id: quitButton
                visible: true
                Layout.preferredWidth: 152
                Layout.alignment: Qt.AlignCenter
                text: qsTr("QUIT")
                onClicked: {
                    Qt.quit()
                }
            }
            Item {
                Layout.fillWidth: false
            }

            ButtonPrimary {
                Layout.preferredWidth: 187
                Layout.alignment: Qt.AlignCenter
                text: qsTr("NEXT")
                onClicked: {
                    stackView.push(hostResolverPage)
                    hostResolverPage.startResolving();
                }
            }
        }
    }
}



