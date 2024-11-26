/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import "../src/qmlcomponents"

Window {
    id: window
    visible: true

    width: 450
    height: 720
    minimumWidth: 450
    minimumHeight: 680

    title: qsTr("Web3 Pi Imager v%1").arg("1.0.0")

    FontLoader {id: roboto;      source: "../src/fonts/Roboto-Regular.ttf"}
    FontLoader {id: robotoLight; source: "../src/fonts/Roboto-Light.ttf"}
    FontLoader {id: robotoBold;  source: "../src/fonts/Roboto-Bold.ttf"}


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
                source: "../src/icons/logo_web3_pi_imager.png"

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


            StackView {
                id: stackView
                anchors.fill: parent
                initialItem: ModeSelector {}
                // initialItem: "SingleModeForm.qml"
                // initialItem: "DualModeForm.qml"
                // initialItem: "Writing.qml"

                Component {
                    id: singleModeForm
                    SingleModeForm {}
                }

                Component {
                    id: dualModeForm
                    DualModeForm {}
                }



            }

        }
    }

}
