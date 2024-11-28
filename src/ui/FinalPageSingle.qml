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
    id: finalPageSingle

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
            Layout.alignment: Qt.AlignCenter
            spacing: 25

            Column {
                id: loader
                Layout.alignment: Qt.AlignCenter
                spacing: 35

                ImText {
                    text: "Searching for a device on the network..."
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                    horizontalAlignment: Text.AlignHCenter
                }

                BusyIndicator {
                    id: busyIndicator
                    running: loading
                    width: 100
                    height: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.theme: Material.Dark
                }
            }


            Column {
                id: textInfo
                visible: false
                Layout.alignment: Qt.AlignCenter
                spacing: 15

                Item {

                    width: 100
                    height: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        anchors.fill: parent
                        source: "icons/success.png"
                        Layout.alignment: Qt.AlignCenter
                    }
                }

                ImText {
                    text: "Now you can monitor the installation process at"
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 13
                    font.italic: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                ImText {
                    text: qsTr("<a href='http://%1.local' style='color: white;'>http://%1.local</a>").arg(settings.hostname)
                    textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 18
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                    onLinkActivated: {
                        Qt.openUrlExternally(link)
                    }
                }

                ImText {

                    topPadding: 24
                    text: "To log in via ssh use credentials:"
                    color: "#fff"
                    font.pointSize: 13
                    font.italic: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                ImText {
                    text: "ethereum:ethereum"
                    color: "#fff"
                    font.pointSize: 15
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Item {
                    height: 10
                    width: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ImText {
                    text: "More information at"
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
                    font.pointSize: 13
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                    onLinkActivated: {
                        Qt.openUrlExternally(link)
                    }
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
            text: qsTr("Quit")
            onClicked: {
                Qt.quit()
            }
        }
    }

    Component.onCompleted: {
        console.log("Page entered in StackView");
        timeoutTimer.start();
    }

    Timer {
        id: timeoutTimer
        interval: 10000
        running: true
        repeat: false
        onTriggered: {
            loader.visible = false
            textInfo.visible = true
        }
    }
}
