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
    id: writingPage

    property string mode
    property var hints: [
        "For more information head to <a href='https://www.web3pi.io' style='color: \"#249EC7\"'>www.web3pi.io</a>",
        qsTr("After writing the image, monitor the installation process at:<br> <a href='http://%1.local' style='color: \"#249EC7\"'>http://%1.local</a>").arg(settings.hostname),
        "After installation, log in via SSH using credentials:<br></br>ethereum:ethereum",
    ]

    signal end(string mode)

    ColumnLayout {
        id: writingProcess
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 20
        anchors.bottomMargin: 45
        anchors.fill: parent

        ColumnLayout {
            id: columnLayoutProgress
            spacing: 0
            Layout.topMargin: 70

            ImText {
                id: progressText
                visible: true
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.bottomMargin: 25
                text: qsTr("Preparing to write...")
                font.pixelSize: 20
            }

            ImText {
                id: progressValue
                font.bold: true
                visible: true
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.bottomMargin: 35
                font.pixelSize: 64
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
                        GradientStop { position: 0.0; color: "#e5447a" }
                        GradientStop { position: 1.0; color: Material.primary }
                        orientation: Gradient.Horizontal
                    }
                }
                Component.onCompleted: {
                    contentItem.implicitHeight = 8
                }

            }

        }

        ImText {
            text: getInfoText()
            color: "#fff"
            font.pixelSize: 20
            font.italic: true
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 40
        }

        TextInfo {
            property int currentIndex: 0

            text: hints[currentIndex]
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 50
            textFormat: Text.RichText
            onLinkActivated: (link) => Qt.openUrlExternally(link)


            Timer {
                interval: 10000
                running: true
                repeat: true
                onTriggered: {
                    parent.currentIndex = (parent.currentIndex + 1) % hints.length;
                    parent.text = hints[parent.currentIndex];
                }
            }

        }

        Item {
            Layout.fillHeight: true
        }

        ButtonSecondary {
            Layout.preferredWidth: 255
            id: cancelwritebutton
            text: qsTr("CANCEL")
            onClicked: {
                progressText.text = qsTr("Cancelling...")
                imageWriter.cancelWrite()
            }
            Layout.alignment: Qt.AlignCenter
            visible: true
        }
        ButtonSecondary {
            Layout.preferredWidth: 255
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
        cancelwritebutton.visible = true
        cancelverifybutton.visible = false
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


