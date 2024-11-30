/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
import "components"

ApplicationWindow {
    id: window
    visible: true

    width: imageWriter.isEmbeddedMode() ? -1 : 480
    height: imageWriter.isEmbeddedMode() ? -1 : 730
    minimumWidth: imageWriter.isEmbeddedMode() ? -1 : 480
    minimumHeight: imageWriter.isEmbeddedMode() ? -1 : 730

    title: qsTr("Web3 Pi Imager v%1").arg(imageWriter.constantVersion())

    signal saveSettingsSignal(var settings)

    property bool dualMode: false;
    property bool initialized: false
    property bool hasSavedSettings: false

    FontLoader {id: roboto;      source: "fonts/Roboto-Regular.ttf"}
    FontLoader {id: robotoLight; source: "fonts/Roboto-Light.ttf"}
    FontLoader {id: robotoBold;  source: "fonts/Roboto-Bold.ttf"}

    Component.onCompleted: {
        if (!initialized) {
            initialize()
            if (imageWriter.hasSavedCustomizationSettings()) {
                applySettings()
            }
        }
    }

    Shortcut {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: {
            if (!progressBar.visible) {
                Qt.quit()
            }
        }
    }

    ColumnLayout {
        id: bg
        spacing: 0
        anchors.fill: parent

        Rectangle {
            id: logoContainer
            implicitHeight: window.height/5

            Image {
                id: image
                source: "icons/logo_web3_pi_imager.png"
                width: window.width
                height: window.height / 5
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignLeft
                anchors.left: logoContainer.left
                anchors.leftMargin: 20
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

            StackView {
                id: stackView
                anchors.fill: parent
                initialItem: ModeSelector {
                    id: modeSelector
                }
            }
        }
    }

    Settings {
        id: settings
    }

    AdvancedSettings {
        id: advancedSettings
    }

    SingleModeForm {
        id: singleModeForm
        visible: false
    }

    DualModeForm {
        id: dualModeForm
        visible: false
    }

    WritingPage {
        id: writingPage
        objectName: "writingPage"
        visible: false
        onEnd: {
            stackView.push(insertingPageSingle)
        }
    }

    InsertingPageSingle {
        id: insertingPageSingle
        visible: false
    }

    FinalPageSingle {
        id: finalPageSingle
        objectName: "finalPageSingle"
        visible: false
    }

    StoragePopup {
        id: dstpopup
        onSelected: {
            if (!imageWriter.readyToWrite()) {
                // TODO: show error ... ?
                return
            }
            confirmwritepopup.askForConfirmation()
        }
    }

    MsgPopup {
        id: msgpopup
        onOpened: {
            forceActiveFocus()
        }
    }

    MsgPopup {
        id: quitpopup
        continueButton: false
        yesButton: true
        noButton: true
        title: qsTr("Are you sure you want to quit?")
        text: qsTr("Raspberry Pi Imager is still busy.<br>Are you sure you want to quit?")
        onYes: {
            Qt.quit()
        }
    }

    MsgPopup {
        id: confirmwritepopup
        continueButton: false
        yesButton: true
        noButton: true
        title: qsTr("Warning")
        modal: true
        onYes: startWrite()

        function askForConfirmation() {
            text = qsTr("All existing data on '%1' will be erased.<br>Are you sure you want to continue?").arg(settings.selectedDsc)
            openPopup()
        }
    }

    MsgPopup {
        id: updatepopup
        continueButton: false
        yesButton: true
        noButton: true
        property url url
        title: qsTr("Update available")
        text: qsTr("There is a newer version of Imager available.<br>Would you like to visit the website to download it?")
        onYes: {
            Qt.openUrlExternally(url)
        }
    }

    function initialize() {
        // TODO
        // chkTelemtry.checked = imageWriter.getBoolSetting("telemetry")
        const savedSettings = imageWriter.getSavedCustomizationSettings()

        singleModeForm.initialize(savedSettings)
        // dualModeForm.initialize(savedSettings)
        advancedSettings.initialize(savedSettings)

        initialized = true
    }

    function startWrite() {
        stackView.push(writingPage)
        imageWriter.setVerifyEnabled(true)
        imageWriter.startWrite()
    }
}
