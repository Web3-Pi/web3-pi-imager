/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import "../src/qmlcomponents"

Window {
    id: window
    visible: true

    width: 450
    height: 680
    minimumWidth: 450
    minimumHeight: 680

    title: qsTr("Web3 Pi Imager v%1").arg("1.0.0")

    FontLoader {id: roboto;      source: "../src/fonts/Roboto-Regular.ttf"}
    FontLoader {id: robotoLight; source: "../src/fonts/Roboto-Light.ttf"}
    FontLoader {id: robotoBold;  source: "../src/fonts/Roboto-Bold.ttf"}


    ColumnLayout {
        id: bg
        spacing: 0
        anchors.fill: parent

        Rectangle {
            id: logoContainer
            implicitHeight: window.height/5

            Image {
                id: image
                source: "../src/icons/logo_web3_pi_imager.png"

                // Specify the maximum size of the image
                width: window.width
                height: window.height / 5

                // Within the image's specified size rectangle, resize the
                // image to fit within the rectangle while keeping its aspect
                // ratio the same.  Preserving the aspect ratio implies some
                // extra padding between the Image's extend and the actual
                // image content: align left so all this padding is on the
                // right.
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignLeft

                // Keep the left side of the image 40 pixels from the left
                // edge
                anchors.left: logoContainer.left
                anchors.leftMargin: 20

                // Equal padding above and below the image
                anchors.top: logoContainer.top
                anchors.bottom: logoContainer.bottom
                anchors.topMargin: window.height / 40
                anchors.bottomMargin: window.height / 40
            }
        }

        Rectangle {
            color: "#e51763"
            implicitWidth: window.width
            implicitHeight: window.height * (1 - 1/5)

            Layout.fillHeight: true

            ColumnLayout {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 35
                anchors.leftMargin: 35
                anchors.bottomMargin: 35
                // anchors.topMargin: 35
                anchors.fill: parent


                ColumnLayout {
                    id: columnLayoutMode
                    spacing: 40
                    Layout.topMargin: 30

                    ImText {
                        text: "Select operating mode:"
                    }

                    // Single Mode Item
                    Rectangle {
                        width: 300
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
                                    source: "../src/icons/mode_single"
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
                                    text: "Single Mode Device"

                                    font.bold: true
                                    font.pixelSize: 18
                                    color: "#fff"
                                    Layout.fillWidth: true
                                }


                                Text {
                                    Layout.fillWidth: true
                                    text: "Execution and Consensus layer\non one device.\nRaspberry Pi 5 recommended"
                                    font.pixelSize: 11
                                    wrapMode: Text.WordWrap
                                    color: "#eee"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: console.log("Analytics selected")
                        }
                    }

                    // Dual Mode Item
                    Rectangle {
                        width: 350
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
                                color: "transparent"
                                border.width: 0
                                Image {
                                    source: "../src/icons/mode_dual"
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
                                    text: "Dual Mode Device"
                                    font.bold: true
                                    font.pixelSize: 18
                                    color: "#cd2355"
                                    Layout.fillWidth: true
                                }


                                Text {
                                    Layout.fillWidth: true
                                    text: "Two sets of devices required.\nMinimum is 2 x Raspberry Pi 4.\n1. Execution layer (min. 2TB storage)\n2. Consensus layer (~ 0.5TB storage)"
                                    font.pixelSize: 11
                                    wrapMode: Text.WordWrap
                                    color: "#cd2355"
                                }
                            }
                        }


                        MouseArea {
                            anchors.fill: parent
                            onClicked: console.log("Analytics selected")
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
                    id: cancelwritebutton
                    text: qsTr("Next")
                    Layout.alignment: Qt.AlignCenter
                    visible: true
                }

            }

        }
    }

}
