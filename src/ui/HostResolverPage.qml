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
    id: hostResolverPage

    property string resolvedIp

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
                visible: true

                ImText {
                    text: "Searching for a device on the network...\n\nIt can take up to 4 minutes after starting the device."
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                    horizontalAlignment: Text.AlignHCenter
                }

                BusyIndicator {
                    id: busyIndicator
                    running: true
                    width: 100
                    height: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.theme: Material.Dark
                }
            }

            Column {
                id: successInfo
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
                    onLinkActivated: (link) => Qt.openUrlExternally(link)
                }

                ImText {
                    topPadding: 24
                    text: "After installation is complete, you can log in via SSH using credentials:"
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
                    onLinkActivated: {
                        Qt.openUrlExternally(link)
                    }
                }

            }

            Column {
                id: timeoutInfo
                visible: false
                Layout.alignment: Qt.AlignCenter
                spacing: 35

                Item {

                    width: 100
                    height: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        anchors.fill: parent
                        source: "icons/warning.png"
                        Layout.alignment: Qt.AlignCenter
                    }
                }

                ImText {
                    text: "The device cannot be found on the network.\n\nCheck if it starts correctly or restart"
                    // textFormat: Text.RichText
                    color: "#fff"
                    font.pointSize: 15
                    font.italic: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ImButton {
                    Layout.minimumHeight: 50
                    Layout.preferredWidth: 200
                    Layout.alignment: Qt.AlignCenter
                    padding: 5
                    text: qsTr("Try again")
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.background: "transparent"
                    Material.foreground: "#c7ffffff"
                    background: Rectangle {
                        border.color: "#c7ffffff"
                        border.width: 1
                        radius: 4
                        color: "transparent"
                    }
                    onClicked: startResolving()
                }

            }
        }

        Item {
            Layout.fillHeight: true
        }

        ImButton {
            id: cancelButton
            visible: true
            Layout.minimumHeight: 40
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignCenter
            padding: 5
            text: qsTr("CANCEL SEARCH")
            onClicked: {
                onTimeout()
            }
        }

        ImButton {
            id: quitButton
            visible: false
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

    Timer {
        id: timer
        interval: 240000 // 4 min
        repeat: false
        onTriggered: onTimeout()
    }

    function startResolving() {
        timer.start()
        hostResolver.startResolving(settings.hostname + ".local")
        loader.visible = true
        timeoutInfo.visible = false;
        successInfo.visible = false;
        cancelButton.visible = true
        quitButton.visible = false
    }

    function onHostResolved(hostname, ip) {
        if (hostname === settings.hostname + ".local") {
            resolvedIp = ip
            showMsg("success")
        } else {
            console.log("Unknown hostname: ", hostname)
        }
        timer.stop()
    }

    function onTimeout() {
        hostResolver.stopResolving(settings.hostname + ".local")
        showMsg('timeout')
    }

    function showMsg(type = 'success') {
        if (type === 'success') {
            cancelButton.visible = false
            quitButton.visible = true
            loader.visible = false
            timeoutInfo.visible = false;
            successInfo.visible = true;
        } else if (type === 'timeout') {
            cancelButton.visible = false
            quitButton.visible = true
            loader.visible = false
            successInfo.visible = false;
            timeoutInfo.visible = true;
        }
    }
}
