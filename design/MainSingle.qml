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
    height: 680
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

    Shortcut {
        sequences: ["Shift+Ctrl+X", "Shift+Meta+X"]
        context: Qt.ApplicationShortcut
        onActivated: {
            optionspopup.openPopup()
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


            ColumnLayout {
                id: mainForm
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 35
                anchors.leftMargin: 35
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                anchors.fill: parent


                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 30




                    RowLayout {
                        Layout.topMargin: -5
                        ImText {
                            text: qsTr("Image version:")
                            rightPadding: 5
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        ImComboBox {
                            id: fieldImageVersion
                            model: ["v0.7.3 (latest)", "v0.7.2", "v0.7.1"]
                            background: Rectangle {
                                color: "white"
                                radius: 4
                                border.color: "#9affffff"
                                border.width: 1
                            }
                            selectTextByMouse: true
                            Layout.minimumWidth: 245
                            Layout.minimumHeight: 35
                            font.pointSize: 12

                        }
                    }

                    RowLayout {
                        ImText {
                            text: qsTr("Default Network:")
                            rightPadding: 5
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        ImComboBox {
                            id: fieldNetwork
                            model: ["Ethereum Mainnet", "Ethereum Sepolia", "Ethereum Goerli"]
                            selectTextByMouse: true
                            Layout.minimumWidth: 245
                            Layout.minimumHeight: 35
                            font.pointSize: 12

                        }
                    }


                    RowLayout {
                        ImText {
                            text: qsTr("Set Hostname:")
                            rightPadding: 5

                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        ImTextField {
                            id: fieldHostname
                            text: "eop-1"
                            selectByMouse: true
                            maximumLength: 255
                            validator: RegularExpressionValidator { regularExpression: /[0-9A-Za-z][0-9A-Za-z-]{0,62}/ }
                            Layout.minimumWidth: 205
                            padding: 0
                            font.family: roboto.name
                            font.pointSize: 12
                            Layout.minimumHeight: 35

                        }
                        ImText {
                            text : ".local"
                        }
                    }





                    RowLayout {
                        ImText {
                            text: qsTr("Execution Client:")
                            rightPadding: 5
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        ImComboBox {
                            id: fieldExecutionClient
                            model: ["Geth", "Disabled"]
                            selectTextByMouse: true
                            Layout.preferredWidth: 120
                            Layout.minimumHeight: 35
                            font.pointSize: 12

                        }
                        ImText {
                            text: qsTr("Port:")
                            leftPadding: 5
                        }
                        ImTextField {
                            id: fieldExecutionPort
                            Layout.preferredWidth: 78
                            text: "30303"
                            font.family: roboto.name
                            font.pointSize: 12
                        }
                    }

                    RowLayout {
                        ImText {
                            text: qsTr("Consensus Client:")
                            rightPadding: 5
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        ImComboBox {
                            id: fieldConsensusClient
                            selectTextByMouse: true
                            Layout.preferredWidth: 120
                            Layout.minimumHeight: 35
                            font.pointSize: 12
                            model: ListModel {
                                ListElement { text: "Nimbus" }
                                ListElement { text: "Lighthouse" }
                            }
                            currentIndex: 1
                            textRole: "text"
                            onActivated: {
                                window.consensusclient = model.get(currentIndex).value
                            }

                        }
                        ImText {
                            text: qsTr("Port:")
                            leftPadding: 5
                        }
                        ImTextField {
                            id: fieldConsensusPort
                            Layout.preferredWidth: 78
                            text: "9000"
                            font.family: roboto.name
                            font.pointSize: 12

                        }
                    }
                    ColumnLayout {
                        spacing: 0
                        Material.theme: Material.Dark
                        ImCheckBox {
                            id: monitoring
                            text: qsTr("Enable Grafana monitoring")
                            padding: 0
                            leftPadding: 10

                            Material.foreground: "#ffffff"
                        }
                        ImCheckBox {
                            id: formatStorage
                            text: qsTr("Format storage")
                            padding: 0
                            leftPadding: 10
                            Material.foreground: "#ffffff"
                        }
                    }
                }
                RowLayout {
                    Layout.preferredHeight: 50
                    width: parent.width
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left

                    ImButton {
                        id: advencedbutton
                        text: qsTr("Advanced")
                        Layout.preferredWidth: 120
                        Layout.alignment: Qt.AlignLeft
                        Material.background: "#cd2355"
                        Material.foreground: "#ffffff"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    ImButton {
                        id: continueutton
                        text: qsTr("Next")
                        Layout.preferredWidth: 200
                        Layout.alignment: Qt.AlignRight
                    }
                }


            }

        }

        GroupBox {
            id: groupBox
            width: 200
            height: 200
            title: qsTr("Group Box")
        }
    }

}
