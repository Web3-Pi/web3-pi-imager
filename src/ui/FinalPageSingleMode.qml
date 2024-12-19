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
Rectangle {
    id: background
    color: Material.background
    Item {
        id: finalPageSingleMode
        anchors.fill: parent
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
                    spacing: 30
                    Layout.topMargin: 5

                    ImText {
                        text: "Thank you for choosing Web3 Pi"
                        font.pixelSize: 32
                        font.weight: Font.Medium
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        width: 82
                        height: 105
                        Layout.alignment: Qt.AlignHCenter
                        Image {
                            anchors.fill: parent
                            source: "icons/success.png"
                            Layout.alignment: Qt.AlignCenter
                        }
                    }
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        spacing: 30

                        ColumnLayout {
                            Layout.alignment: Qt.AlignCenter
                            ImText {
                                text: qsTr("Monitor installation process will be available at:")
                                textFormat: Text.RichText
                                Layout.alignment: Qt.AlignCenter
                                horizontalAlignment: Text.AlignHCenter
                                color: "#99ffffff"
                                font.pixelSize: 20
                                font.weight: Font.Medium
                                onLinkActivated: (link) => Qt.openUrlExternally(link)
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignCenter
                                ImText {
                                    text: qsTr("<a href='http://%1.local' style='color: #fff;'>http://%1.local</a>").arg("eop-1")
                                    textFormat: Text.RichText
                                    Layout.alignment: Qt.AlignCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    color: "#99ffffff"
                                    //color: "#fff"
                                    font.pixelSize: 20
                                    font.weight: Font.Medium
                                    onLinkActivated: (link) => Qt.openUrlExternally(link)
                                    visible: true
                                }
                                ImText {
                                    visible: true
                                    text: qsTr("or <a href='http://%1.local' style='color: #ffffff;'>http://%1</a>").arg("192.168.1.77")
                                    textFormat: Text.RichText
                                    Layout.alignment: Qt.AlignCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    color: "#bbffffff"
                                    font.pixelSize: 20
                                    font.weight: Font.Medium
                                    onLinkActivated: (link) => Qt.openUrlExternally(link)
                                }
                            }


                            RowLayout {
                                Layout.alignment: Qt.AlignCenter

                                visible: false
                                ImText {
                                    visible: true
                                    color: "#bbffffff"
                                    font.pixelSize: 15
                                    font.italic: true
                                    text: ("Searching for a device...")
                                }
                                BusyIndicator {
                                    visible: true
                                    id: busyIndicator
                                    running: true
                                    implicitHeight: 40
                                    implicitWidth: 40
                                    Material.theme: Material.Dark
                                    Layout.alignment: Qt.AlignCenter
                                }
                                ButtonOutline {
                                    visible: true
                                    id: control
                                    Layout.alignment: Qt.AlignCenter
                                    Layout.preferredHeight:25
                                    Layout.preferredWidth: 70
                                    font.pixelSize: 10
                                    verticalPadding: 0
                                    topPadding: 0
                                    bottomPadding: 0
                                    spacing: 0
                                    padding: 0
                                    rightPadding: 0
                                    leftPadding: 0
                                    text: qsTr("CANCEL")
                                    Material.foreground: "#bbffffff"
                                    Component.onCompleted: {
                                        control.background.border.color = "#997d7d7d"
                                    }
                                }
                            }
                        }




                        ImText {
                            text: "After installation, log in via SSH using credentials:<br><span style='color: white;'>ethereum:ethereum</span>"
                            textFormat: Text.RichText
                            Layout.alignment: Qt.AlignCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "#99ffffff"
                            font.pixelSize: 20
                            font.weight: Font.Medium
                        }

                        ImText {
                            text: qsTr("More information at: <a href='https://www.web3pi.io' style='color: white;'>www.web3pi.io</a>")
                            textFormat: Text.RichText
                            Layout.alignment: Qt.AlignCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "#99ffffff"
                            font.pixelSize: 20
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
}


