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
    id: window
    visible: true

    width: 480
    height: 730
    minimumWidth: 480
    minimumHeight: 730

    title: qsTr("Web3 Pi Imager v%1").arg("1.0.0")

    property bool dualMode: false;

    FontLoader {id: roboto;      source: "./fonts/Roboto-Regular.ttf"}
    FontLoader {id: robotoLight; source: "./fonts/Roboto-Light.ttf"}
    FontLoader {id: robotoBold;  source: "./fonts/Roboto-Bold.ttf"}
    
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
                source: "./icons/logo_web3_pi_imager.png"

                // Specify the maximum size of the image
                width: window.width
                height: window.height / 5

                // Within the image's specified size rectangle, resize the
                // image to fit within the rectangle while keeping its aspect
                // ratio the same.  Preserving the aspect ratio implies some
                // extra padding between the Image's extend and the actual
                // image content: align left so all this padding is on the
                // right.
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignLeft

                // Keep the left side of the image 40 pixels from the left
                // edge
                anchors.left: logoContainer.left
                anchors.leftMargin: 20

                // Equal padding above and below the image
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

            Material.theme: Material.Light

            StackView {
                id: stackView
                anchors.fill: parent
                initialItem: FinalPageSingle {}
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

    FinalPageSingle {
        id: finalPageSingle
        visible: false
    }

    InsertingPageSingle {
        id: insertingPageSingle
        visible: false
    }
}
