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
    id: insertingPageSingle

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
                // text: qsTr("%1 has been written to<br>%2").arg("Web3PI Imager ver 873 (latest)").arg("Apple Media Sd Card Reader bala bla")
                color: "#fff"
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ImText {
                text: "Now perform the following operations:"
                color: "#fff"
                font.pointSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
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
                stackView.push(finalPageSingle)
            }
        }
    }
}
