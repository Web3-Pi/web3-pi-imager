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

    signal end(bool success)

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 10
        anchors.bottomMargin: 45
        anchors.fill: parent

        ColumnLayout {
            id: searchingInfo
            visible: true
            Layout.alignment: Qt.AlignCenter
            spacing: 25
            Layout.topMargin: 45

            ImText {
                text: "Web3 Pi installer has been\nsuccessfully written to sd card"
                font.pixelSize: 32
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
                font.weight: Font.Medium

            }

            RowLayout {
                Layout.alignment: Qt.AlignCenter
                spacing: 40
                Layout.topMargin: 45
                Layout.bottomMargin: 45
                ImText {
                    color: "#ffffff"
                    font.pixelSize: 20
                    text: ("Searching for a device...")
                }
                BusyIndicator {
                    id: busyIndicator
                    running: true
                    implicitHeight: 57
                    implicitWidth: 57
                    Material.theme: Material.Dark
                    Layout.alignment: Qt.AlignCenter
                }
                ButtonSecondary {
                    visible: true
                    id: control
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredHeight:35
                    Layout.preferredWidth: 109
                    font.pixelSize: 18
                    verticalPadding: 0
                    topPadding: 0
                    bottomPadding: 0
                    spacing: 0
                    padding: 0
                    rightPadding: 0
                    leftPadding: 0
                    text: qsTr("CANCEL")
                    Component.onCompleted: {
                        control.background.radius = 9
                    }
                    onClicked: {
                        stopResolving()
                    }
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
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: false
                    }
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
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: false
                    }
                }
            }
        }
        ColumnLayout {
            id: timeoutInfo
            visible: false
            Layout.alignment: Qt.AlignCenter
            spacing: 35
            Layout.topMargin: 45

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
                Layout.topMargin: 20

                ImText {
                    text: "1. Check your connection"
                    font.family: dmsansItalic.name
                    font.pixelSize: 20
                    font.italic: true
                }

                ImText {
                    text: "2. Make sure that the status LED blinks green"
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
        searchingInfo.visible = true
        finishButton.visible = true
        quitButton.visible = false
        timeoutInfo.visible = false;
        tryAgainButton.visible = false
        background.color = Material.background
    }

    function stopResolving() {
        hostResolver.stopResolving(settings.hostname + ".local")
        timer.stop()
        end(false)
    }

    function onHostResolved(hostname, ip) {
        if (hostname === settings.hostname + ".local") {
            resolvedIp = ip
        } else {
            console.log("Unknown hostname: ", hostname)
        }
        timer.stop()
        end(!!resolvedIp)
    }

    function onTimeout() {
        hostResolver.stopResolving(settings.hostname + ".local")
        background.color = Material.accent
        finishButton.visible = false
        quitButton.visible = true
        tryAgainButton.visible = true
        searchingInfo.visible = false
        timeoutInfo.visible = true;
    }
}

