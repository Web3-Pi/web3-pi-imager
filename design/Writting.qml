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
                id: writingProcess
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 35
                anchors.leftMargin: 35
                anchors.topMargin: 20
                anchors.bottomMargin: 35
                anchors.fill: parent

                ColumnLayout {
                    id: columnLayoutProgress
                    spacing: 0
                    Layout.topMargin: 30

                    ImText {
                        id: progressText
                        color: "white"
                        font.family: robotoBold.name
                        font.bold: true
                        visible: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.bottomMargin: 25
                        text: qsTr("Preparing to write...")
                    }

                    ProgressBar {
                        Layout.bottomMargin: 0
                        id: progressBar
                        Layout.fillWidth: true
                        visible: true
                        Material.background: "#d15d7d"
                        indeterminate: true
                        Material.accent: "#ffffff"
                    }
                }
                Item {
                    Layout.fillHeight: true
                }
                ColumnLayout {
                    id: infoText
                    Layout.alignment: Qt.AlignCenter
                    spacing: 25
                    Column {
                        spacing: 5
                        Layout.bottomMargin: 0

                        ImText {
                            text: "After installation, you can log in via ssh using credentials"
                            color: "#fff"
                            font.pointSize: 13
                            font.italic: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        ImText {
                            text: "ethereum:ethereum"
                            color: "#fff"
                            font.pointSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        Layout.alignment: Qt.AlignCenter
                        spacing: 5

                        ImText {
                            text: "You can monitor the installation process at"
                            textFormat: Text.RichText
                            color: "#fff"
                            font.pointSize: 13
                            font.italic: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        ImText {
                            text: "<a href='http://hostname.local' style='color: white;'>http://hostname.local</a>"
                            textFormat: Text.RichText
                            color: "#fff"
                            font.pointSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            HoverHandler {
                                    cursorShape: Qt.PointingHandCursor
                                }
                        }
                    }

                    Column {
                        Layout.alignment: Qt.AlignCenter
                        spacing: 5

                        ImText {
                            text: "After correct installation you can monitor your node at"
                            textFormat: Text.RichText
                            color: "#fff"
                            font.pointSize: 13
                            font.italic: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        ImText {
                            text: "<a href='http://hostname.local:3000' style='color: white;'>http://hostname.local:3000</a>"
                            textFormat: Text.RichText
                            color: "#fff"
                            font.pointSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        Layout.alignment: Qt.AlignCenter
                        spacing: 5

                        ImText {
                            text: "You can find more information at"
                            textFormat: Text.RichText
                            color: "#fff"
                            font.pointSize: 13
                            font.italic: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        ImText {
                            text: "<a href='https://www.web3pi.io' style='color: white;'>https://www.web3pi.io</a>"
                            textFormat: Text.RichText
                            color: "#fff"
                            font.pointSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
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
                    text: qsTr("CANCEL WRITE")
                    onClicked: {
                        enabled = false
                        progressText.text = qsTr("Cancelling...")
                        imageWriter.cancelWrite()
                    }
                    Layout.alignment: Qt.AlignCenter
                    visible: true
                }
                ImButton {
                    Layout.minimumHeight: 40
                    Layout.preferredWidth: 200
                    padding: 5
                    id: cancelverifybutton
                    text: qsTr("CANCEL VERIFY")
                    onClicked: {
                        enabled = false
                        progressText.text = qsTr("Finalizing...")
                        imageWriter.setVerifyEnabled(false)
                    }
                    Layout.alignment: Qt.AlignCenter
                    visible: false
                }

            }

        }
    }

}
