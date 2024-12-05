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
    id: mainWindow
    visible: true

    width: imageWriter.isEmbeddedMode() ? -1 : 480
    height: imageWriter.isEmbeddedMode() ? -1 : 730
    minimumWidth: imageWriter.isEmbeddedMode() ? -1 : 480
    minimumHeight: imageWriter.isEmbeddedMode() ? -1 : 730

    title: qsTr("Web3 Pi Imager v%1").arg(imageWriter.constantVersion())

    signal saveSettingsSignal(var settings)

    property bool initialized: false
    property bool hasSavedSettings: false

    FontLoader {id: roboto;      source: "fonts/Roboto-Regular.ttf"}
    FontLoader {id: robotoLight; source: "fonts/Roboto-Light.ttf"}
    FontLoader {id: robotoBold;  source: "fonts/Roboto-Bold.ttf"}

    Component.onCompleted: {
        if (!initialized) {
            initialize()
            if (imageWriter.hasSavedCustomizationSettings()) {
                settings.apply()
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
            implicitHeight: mainWindow.height/5

            Image {
                id: image
                source: "icons/logo_web3_pi_imager.png"
                width: mainWindow.width
                height: mainWindow.height / 5
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignLeft
                anchors.left: logoContainer.left
                anchors.leftMargin: 20
                anchors.top: logoContainer.top
                anchors.bottom: logoContainer.bottom
                anchors.topMargin: mainWindow.height / 40
                anchors.bottomMargin: mainWindow.height / 40
            }
        }

        Rectangle {
            color: "#e51763"
            implicitWidth: mainWindow.width
            implicitHeight: mainWindow.height * (1 - 1/5)

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

    VersionManager {
        id: versionManager
        objectName: "versionManager"
    }

    SingleModeForm {
        id: singleModeForm
        visible: false
        onNext:() => chooseStorage("single")
    }

    DualModeForm {
        id: dualModeForm
        visible: false
        onNext: () => chooseStorage("execution")
    }

    StoragePopup {
        id: storagePopup
        onSelected: (mode) => startWrite(mode)
    }

    WritingPage {
        id: writingPage
        objectName: "writingPage"
        visible: false
        onEnd: (mode) => afterWriting(mode)
    }

    AfterWritingPageSingle {
        id: afterWritingPageSingle
        visible: false
    }

    AfterWritingPageExecution {
        id: afterWritingPageExecution
        visible: false
    }

    AfterWritingPageConsensus {
        id: afterWritingPageConsensus
        visible: false
    }

    HostResolverPage {
        id: hostResolverPage
        objectName: "hostResolverPage"
        visible: false
    }

    MsgPopup {
        id: updatePopup
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

    MsgPopup {
        id: warningPopup
        continueButton: true
        yesButton: false
        noButton: false
        title: qsTr("Error")
    }


    function initialize() {
        // TODO
        // chkTelemtry.checked = imageWriter.getBoolSetting("telemetry")
        const savedSettings = imageWriter.getSavedCustomizationSettings()

        singleModeForm.initialize(savedSettings)
        dualModeForm.initialize(savedSettings)
        advancedSettings.initialize(savedSettings)

        initialized = true
    }

    function chooseStorage(mode) {
        storagePopup.mode = mode
        storagePopup.open()
    }

    function startWrite(mode) {
        settings.mode = mode;
        settings.apply();
        writingPage.mode = mode
        stackView.push(writingPage)
        imageWriter.setVerifyEnabled(true)
        imageWriter.startWrite()
    }

    function afterWriting(mode) {
        if (mode === "single") {
            stackView.push(afterWritingPageSingle)
        } else if (mode === "execution") {

            stackView.pop()
            stackView.push(afterWritingPageExecution)
        } else if (mode === "consensus") {
            stackView.push(afterWritingPageConsensus)
        }
    }

    function onNetworkInfo(msg) {
        warningPopup.text = qsTr("No internet connection\n%1").arg(msg)
        warningPopup.openPopup()
    }
}
