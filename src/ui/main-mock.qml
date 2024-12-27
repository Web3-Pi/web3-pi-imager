/**
 * This file is intended solely for UI prototyping purposes in QT Design Studio.
 * It is a duplicate of the main.qml file stripped of any dependencies and references to core code to run the project in QT Design Studio.
 *
 * Warning!
 * Changes in this file do not affect the output code after the application has been compiled.
 * It is just a mock for visual prototyping. Any changes must be moved to the main.qml file
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import "components"

Window {
    id: mainWindow
    visible: true

    width: 690
    height: 780
    flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint

    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    title: qsTr("Web3 Pi Imager v%1").arg("0.1.0")

    FontLoader { id: dmsansItalic; source: "fonts/DMSans-Italic.ttf" }
    FontLoader { id: dmsansMedium; source: "fonts/DMSans-Medium.ttf" }
    FontLoader { id: dmsansBold; source: "fonts/DMSans-Bold.ttf" }
    FontLoader { id: dmsans; source: "fonts/DMSans-Regular.ttf" }
    FontLoader { id: outfitMedium; source: "fonts/Outfit-Medium.ttf" }
    FontLoader { id: outfit; source: "fonts/Outfit-Regular.ttf" }
    FontLoader { id: outfitBold; source: "fonts/Outfit-Bold.ttf" }
    
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
            id: header
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            implicitHeight: 160
            implicitWidth: mainWindow.width
            z: 1
            color: Material.foreground

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
                initialItem: HostResolverPage {}
            }
        }
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
        visible: false
    }

    AdvancedSettings {
        id: advancedSettings
    }
    Settings {
        id: settings
    }

    HostResolverPage {
        id: hostResolverPage
        visible: false
    }
    AfterWritingPageConsensus {
        id: afterWritingPageConsensus
        visible: false
    }
    AfterWritingPageSingle {
        id: afterWritingPageSingle
        visible: false
    }
    AfterWritingPageExecution {
        id: afterWritingPageExecution
        visible: false
    }
    FinalPageDualMode {
        id: finalPageDualMode
        visible: false
    }

    StoragePopup {
        id: storagePopup
        onSelected: (mode) => startWrite(mode)
    }

    MsgPopup {
        id: confirmwritepopup
        continueButton: false
        yesButton: true
        noButton: true
        title: qsTr("Warning")
        modal: true

        function askForConfirmation() {
            text = qsTr("All existing data on '%1' will be erased.<br>Are you sure you want to continue?").arg(settings.selectedDsc)
            openPopup()
        }
    }

    Component.onCompleted: {
        // confirmwritepopup.askForConfirmation()
        // storagePopup.open()
        // advancedSettings.open()
    }

}
