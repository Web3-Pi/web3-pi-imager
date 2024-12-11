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

    property string mode

    signal end(string mode)

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
                visible: true
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.bottomMargin: 25
                text: qsTr("Preparing to write...")
                font.pointSize: 20
            }

            ImText {
                id: progressValue
                font.bold: true
                visible: true
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.bottomMargin: 25
                font.pointSize: 64
            }

            ProgressBar {
                id: progressBar
                height: 8
                Layout.bottomMargin: 0
                Layout.fillWidth: true
                visible: true
                indeterminate: true
                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 8
                    height: 8
                    y: (progressBar.height - height) / 2
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Material.accent }
                        GradientStop { position: 1.0; color: Material.primary }
                        orientation: Gradient.Horizontal
                    }
                }
                Component.onCompleted: {
                    contentItem.implicitHeight = 8
                    contentItem.scale = 1
                }

            }

        }
        Item {
            Layout.fillHeight: true
        }

        ImText {
            text: getInfoText()
            color: "#fff"
            font.pointSize: 20
            font.italic: true
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignCenter
        }
        Item {
            Layout.fillHeight: true
        }

        Item {
            Layout.fillHeight: true
        }

        ButtonSecondary {
            Layout.minimumHeight: 40
            Layout.preferredWidth: 200
            id: cancelwritebutton
            text: qsTr("CANCEL WRITE")
            onClicked: {
                progressText.text = qsTr("Cancelling...")
                imageWriter.cancelWrite()
            }
            Layout.alignment: Qt.AlignCenter
            visible: true
        }
        ButtonSecondary {
            Layout.minimumHeight: 40
            Layout.preferredWidth: 200
            id: cancelverifybutton
            text: qsTr("CANCEL VERIFY")
            onClicked: {
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

            progressText.text = qsTr("Writing...")
            progressValue.text = qsTr("%1%").arg(Math.floor(newPos*100))
            progressBar.indeterminate = false
            progressBar.value = newPos

            progressBar.Material.accent = Material.accent
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

            progressText.text = qsTr("Verifying...")
            progressValue.text = qsTr("%1%").arg(Math.floor(newPos*100))
            progressBar.Material.accent = "#6cc04a"
            progressBar.value = newPos
        }
    }

    function onPreparationStatusUpdate(msg) {
        progressText.text = qsTr("Preparing to write... (%1)").arg(msg)
    }

    function onError(msg) {
        warningPopup.title = qsTr("Error")
        warningPopup.text = msg
        warningPopup.openPopup()
        stackView.pop()
    }

    function onSuccess() {
        imageWriter.setDst("")
        progressText.text = ""
        progressValue.text = ""
        progressBar.value = 0
        progressBar.Material.accent = Material.accent
        end(mode)
    }

    function onCancelled() {
        stackView.pop()
    }

    function onFinalizing() {
        progressText.text = qsTr("Finalizing...")
    }

    function onNetworkInfo(msg) {
        networkInfo.text = msg
    }

    function getInfoText() {
        if (mode === "single") {
            return qsTr("The image is now being written for a Single Mode Device\n(execution and consensus client).")
        } else if (mode === "execution") {
            return qsTr("The image is now being written for a Execution Device")
        } else if (mode === "consensus") {
            return qsTr("The image is now being written for a Consensus Device")
        }
        return qsTr("The image is now being written")
    }


}


