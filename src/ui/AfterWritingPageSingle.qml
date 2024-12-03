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
                text: qsTr("<b>%1</b>has been written to<br><b>%2</b>").arg(settings.selectedOS).arg(settings.selectedDsc)
                color: "#fff"
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }

            ImText {
                text: "If you want to install now, follow these steps:"
                color: "#fff"
                font.pointSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }

            ColumnLayout {

                ImText {
                    text: "1. Insert the card into the Raspberry Pi"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                }

                ImText {
                    text: "2. Connect the necessary cables"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                }

                ImText {
                    text: "3. Turn on the device"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                }
            }
            Item {
                Layout.alignment: Qt.AlignCenter
                width: 150
                height: 150
                Image {
                    anchors.fill: parent
                    source: "icons/inserting.png"
                    Layout.alignment: Qt.AlignCenter
                }
            }
            ImText {
                text: qsTr("If you want to install later, close the application,<br>and the installation process, after starting the device,<br>can be monitored at <b><a href='http://%1.local' style='color: white;'>http://%1.local</a></b>").arg(settings.hostname)
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
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.preferredHeight: 50
            width: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ImButton {
                id: quitButton
                visible: true
                Layout.minimumHeight: 40
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignCenter
                padding: 5
                topInset: 2
                bottomInset: 2
                text: qsTr("Quit")
                Material.background: "transparent"
                Material.foreground: "#c7ffffff"
                background: Rectangle {
                    border.color: "#c7ffffff"
                    border.width: 1
                    radius: 4
                    color: "transparent"
                }
                onClicked: {
                    Qt.quit()
                }
            }
            Item {
                Layout.fillWidth: true
            }

            ImButton {
                Layout.minimumHeight: 40
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignCenter
                padding: 5
                text: qsTr("Next")
                onClicked: {
                    stackView.push(hostResolverPage)
                    hostResolverPage.startResolving();
                }
            }
        }
    }
}
