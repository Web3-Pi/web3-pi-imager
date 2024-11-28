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
            Layout.topMargin: 80

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

        Item {
            Layout.alignment: Qt.AlignCenter
            width: 150
            height: 150
            AnimatedImage {
                anchors.fill: parent
                source: "icons/writing.gif"
                clip: true
                Layout.alignment: Qt.AlignCenter
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
        // msgpopup.title = qsTr("Write Successful")
        // if (settings.selectedDsc === qsTr("Erase"))
        //     msgpopup.text = qsTr("<b>%1</b> has been erased<br><br>You can now remove the SD card from the reader").arg(settings.selectedDsc)
        // else if (imageWriter.isEmbeddedMode()) {
        //     //msgpopup.text = qsTr("<b>%1</b> has been written to <b>%2</b>").arg(osbutton.text).arg(dstbutton.text)
        //     /* Just reboot to the installed OS */
        //     Qt.quit()
        // }
        // else
        //     msgpopup.text = qsTr("<b>%1</b> has been written to <b>%2</b><br><br>You can now remove the SD card from the reader").arg(settings.selectedOS).arg(settings.selectedDsc)
        // if (imageWriter.isEmbeddedMode()) {
        //     msgpopup.continueButton = false
        //     msgpopup.quitButton = true
        // }

        // msgpopup.openPopup()
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
