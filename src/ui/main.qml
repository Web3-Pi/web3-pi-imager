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

ApplicationWindow {
    id: mainWindow
    visible: true

    width: 690
    height: 780
    flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint

    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    title: qsTr("Web3 Pi Imager v%1").arg(imageWriter.constantVersion())

    signal saveSettingsSignal(var settings)

    property bool initialized: false
    property bool hasSavedSettings: false

    FontLoader { id: dmsans; source: "fonts/DMSans-VariableFont_opsz_wght.ttf" }
    FontLoader { id: outfit; source: "fonts/Outfit-VariableFont_wght.ttf" }

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
        spacing: 0
        anchors.fill: parent
        Rectangle {
            id: header
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            implicitHeight: 160
            implicitWidth: mainWindow.width
            color: Material.foreground
            z: 1

            Image {
                width: 732
                height: 203
                source: "./icons/logo_web3_pi_imager.png"
                anchors.horizontalCenterOffset: 63
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignLeft
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.margins: -25
                anchors.topMargin: 0
                z: 1
            }
        }

        Rectangle {
            id: background
            color: Material.background
            implicitWidth: mainWindow.width
            implicitHeight: mainWindow.height - header.height

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
        id:  singleModeForm
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

    FinalPageDualMode {
        id: finalPageDualMode
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

        // versionManager.fetchOSList()

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
