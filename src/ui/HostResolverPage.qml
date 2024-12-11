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

Item {
    id: hostResolverPage

    property string resolvedIp

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 10
        anchors.bottomMargin: 45
        anchors.fill: parent

        Item {
            // Layout.fillHeight: true
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 25

            Layout.topMargin: 40

            Column {
                id: loader
                Layout.alignment: Qt.AlignCenter
                spacing: 65
                visible: true
                Layout.topMargin: 40

                ColumnLayout {

                    ImText {
                        text: "Searching for a device on the network..."
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                    }

                    ImText {
                        text: "It can take up to 4 minutes after starting the device."
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        color: "#99ffffff"
                    }
                }


                BusyIndicator {
                    id: busyIndicator
                    running: true
                    width: 132
                    height: 132
                    anchors.horizontalCenter: parent.horizontalCenter
                    Material.theme: Material.Dark
                }
                Item {
                    // Layout.fillHeight: true
                }
            }

            ColumnLayout {
                id: successInfo
                visible: false
                Layout.alignment: Qt.AlignCenter
                spacing: 40
                Layout.topMargin: 10


                ImText {
                    text: "Thank you for choosing Web3 Pi"
                    font.pixelSize: 28
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
                    spacing: 10
                    Layout.topMargin: 15

                    ImText {
                        text: qsTr("Monitor installation process at: <a href='http://%1.local' style='color: white;'>http://%1.local</a>").arg(settings.hostname)
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                    }

                    ImText {
                        text: "Log in via SSH using credentials: <span style='color: white;'>ethereum:ethereum</span>"
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                    }

                    ImText {
                        text: qsTr("More information at: <a href='https://www.web3pi.io' style='color: white;'>www.web3pi.io</a>")
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                    }
                }
            }

            ColumnLayout {
                id: timeoutInfo
                visible: false
                Layout.alignment: Qt.AlignCenter
                spacing: 35
                Layout.topMargin: 10

                Item {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    width: 400
                    height: 182
                    Layout.fillWidth: false
                    Image {
                        anchors.fill: parent
                        source: "icons/warning.png"
                        Layout.alignment: Qt.AlignCenter
                    }
                }

                ImText {
                    text: "The device cannot be found on your network"
                    font.pixelSize: 22
                    color: "#FFA200"
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    ImText {
                        text: "1. Check your connection"
                        font.family: dmsansItalic.name
                        font.pixelSize: 20
                        font.italic: true
                    }

                    ImText {
                        text: "2. Make sure that the blinker blips green blops"
                        font.family: dmsansItalic.name
                        font.pixelSize: 20
                        font.italic: true
                    }

                    ImText {
                        text: "3. Check if your Raspberry Pi is turned on"
                        font.family: dmsansItalic.name
                        font.pixelSize: 20
                        font.italic: true
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

            ButtonSecondary {
                id: cancelButton
                visible: true
                Layout.preferredWidth: 255
                Layout.alignment: Qt.AlignCenter
                text: qsTr("CANCEL SEARCH")
                onClicked: {
                    onTimeout()
                }
            }

            ButtonOutline {
                id: quitButton
                visible: false
                Layout.preferredWidth: 152
                Layout.alignment: Qt.AlignCenter
                text: qsTr("QUIT")
                onClicked: {
                    Qt.quit()
                }
            }

            ButtonPrimary {
                id: finishButton
                visible: false
                Layout.preferredWidth: 187
                Layout.alignment: Qt.AlignCenter
                text: qsTr("FINISH")
                onClicked: {
                    Qt.quit()
                }
            }

            ButtonPrimary {
                id: tryAgainButton
                visible: false
                Layout.preferredWidth: 187
                Layout.alignment: Qt.AlignCenter
                text: qsTr("TRY AGAIN")
                onClicked: startResolving()
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
        tryAgainButton.visible = false
        finishButton.visible = false
        background.color = Material.background
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
            background.color = Material.background
            finishButton.visible = true
            cancelButton.visible = false
            quitButton.visible = false
            tryAgainButton.visible = false
            loader.visible = false
            timeoutInfo.visible = false;
            successInfo.visible = true;
        } else if (type === 'timeout') {
            background.color = Material.accent
            finishButton.visible = false
            cancelButton.visible = false
            quitButton.visible = true
            tryAgainButton.visible = true
            loader.visible = false
            successInfo.visible = false;
            timeoutInfo.visible = true;
        }
    }
}

