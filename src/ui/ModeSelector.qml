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
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.bottomMargin: 35
        anchors.topMargin: 35
        anchors.fill: parent

        ColumnLayout {
            id: columnLayoutMode
            spacing: 40
            Layout.topMargin: 30
            Layout.bottomMargin: 30

            ImText {
                text: "Select operating mode:"
            }

            // Single Mode Item
            Rectangle {
                id: singleModeBg
                width: 300
                height: 130
                radius: 10
                border.color: "#a60434"
                border.width: 1
                Layout.rightMargin: 20
                Layout.leftMargin: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: "#fff"

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: Qt.LeftToRight
                    spacing: 10

                    Rectangle {
                        Layout.leftMargin: 20
                        Layout.rightMargin: 10
                        width: 64
                        height: 64
                        radius: 8
                        color: "#fae0e0"
                        border.width: 0
                        Image {
                            source: "./icons/mode_single.png"
                            sourceSize.width: 64
                            fillMode: Image.Stretch
                            smooth: true
                        }
                    }

                    ColumnLayout {
                        spacing: 5
                        Layout.fillWidth: true
                        Layout.rightMargin: 20
                        Text {
                            id: singleModeLabel
                            text: "Single Mode Device"
                            font.bold: true
                            font.pixelSize: 18
                            color: "#cd2355"
                            Layout.fillWidth: true
                        }


                        Text {
                            id: singleModeText
                            Layout.fillWidth: true
                            text: "Execution and Consensus layer\non one device.\nRaspberry Pi 5 recommended"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                            color: "#cd2355"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: setDualMode(false)
                }
            }

            // Dual Mode Item
            Rectangle {
                id: dualModeBg
                width: 350
                height: 130
                radius: 10
                border.color: "#fff"
                border.width: 1
                Layout.rightMargin: 20
                Layout.leftMargin: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    layoutDirection: Qt.LeftToRight
                    spacing: 10


                    Rectangle {
                        Layout.leftMargin: 20
                        Layout.rightMargin: 10
                        width: 64
                        height: 64
                        radius: 8
                        color: "#fae0e0"
                        border.width: 0
                        Image {
                            source: "./icons/mode_dual.png"
                            sourceSize.width: 64
                            fillMode: Image.Stretch
                            smooth: true
                        }
                    }

                    ColumnLayout {
                        spacing: 5
                        Layout.fillWidth: true
                        Layout.rightMargin: 20
                        Text {
                            id: dualModeLabel
                            text: "Dual Mode Device"
                            font.bold: true
                            font.pixelSize: 18
                            color: "#fff"
                            Layout.fillWidth: true
                        }


                        Text {
                            id: dualModeText
                            Layout.fillWidth: true
                            text: "Two sets of devices required.\nMinimum is 2 x Raspberry Pi 4.\n1. Execution layer (min. 2TB storage)\n2. Consensus layer (~ 0.5TB storage)"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                            color: "#eee"
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: setDualMode(true)
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }


        ImButton {
            Layout.minimumHeight: 40
            Layout.preferredWidth: 200
            padding: 5
            id: nextbutton
            text: qsTr("Next")
            Layout.alignment: Qt.AlignCenter
            onClicked: {
                stackView.push(dualMode ? dualModeForm : singleModeForm)
            }
        }

    }


    function setDualMode(isDualMode = true) {
        if (isDualMode) {
            dualMode = true

            singleModeBg.color = "transparent"
            singleModeBg.border.color = "#fff"
            singleModeLabel.color = "#fff"
            singleModeText.color = "#eee"

            dualModeBg.color = "#fff"
            dualModeBg.border.color = "#a60434"
            dualModeLabel.color = "#cd2355"
            dualModeText.color = "#cd2355"

        } else {
            dualMode = false

            singleModeBg.color = "#fff"
            singleModeBg.border.color = "#a60434"
            singleModeLabel.color = "#cd2355"
            singleModeText.color = "#cd2355"

            dualModeBg.color = "transparent"
            dualModeBg.border.color = "#fff"
            dualModeLabel.color = "#fff"
            dualModeText.color = "#eee"
        }
    }
}




