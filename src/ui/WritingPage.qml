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
    id: writingPage

    property bool isDualMode: false

    signal end()

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
                id: progressBar
                Layout.bottomMargin: 0
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


    /* Slots for signals imagewrite emits */
    function onDownloadProgress(now, total) {
        var newPos
        if (total) {
            newPos = now/(total+1)
        } else {
            newPos = 0
        }
        if (progressBar.value !== newPos) {
            if (progressText.text === qsTr("Cancelling..."))
                return

            progressText.text = qsTr("Writing... %1%").arg(Math.floor(newPos*100))
            progressBar.indeterminate = false
            progressBar.value = newPos
        }
    }

    function onVerifyProgress(now,total) {
        var newPos
        if (total) {
            newPos = now/total
        } else {
            newPos = 0
        }

        if (progressBar.value !== newPos) {
            if (cancelwritebutton.visible) {
                cancelwritebutton.visible = false
                cancelverifybutton.visible = true
            }

            if (progressText.text === qsTr("Finalizing..."))
                return

            progressText.text = qsTr("Verifying... %1%").arg(Math.floor(newPos*100))
            progressBar.Material.accent = "#6cc04a"
            progressBar.value = newPos
        }
    }

    function onPreparationStatusUpdate(msg) {
        progressText.text = qsTr("Preparing to write... (%1)").arg(msg)
    }

    function onOsListPrepared() {
        fetchOSlist()
    }

    function onError(msg) {
        msgpopup.title = qsTr("Error")
        msgpopup.text = msg
        msgpopup.openPopup()
        end()
    }

    function onSuccess() {
        msgpopup.title = qsTr("Write Successful")
        if (window.selectedos === qsTr("Erase"))
            msgpopup.text = qsTr("<b>%1</b> has been erased<br><br>You can now remove the SD card from the reader").arg(window.selecteddstdesc)
        else if (imageWriter.isEmbeddedMode()) {
            //msgpopup.text = qsTr("<b>%1</b> has been written to <b>%2</b>").arg(osbutton.text).arg(dstbutton.text)
            /* Just reboot to the installed OS */
            Qt.quit()
        }
        else
            msgpopup.text = qsTr("<b>%1</b> has been written to <b>%2</b><br><br>You can now remove the SD card from the reader").arg(window.selectedos).arg(window.selecteddstdesc)
        if (imageWriter.isEmbeddedMode()) {
            msgpopup.continueButton = false
            msgpopup.quitButton = true
        }

        msgpopup.openPopup()
        imageWriter.setDst("")
        end()
    }



    function onCancelled() {
        end()
    }



    function onFinalizing() {
        progressText.text = qsTr("Finalizing...")
    }

    function onNetworkInfo(msg) {
        networkInfo.text = msg
    }


}
