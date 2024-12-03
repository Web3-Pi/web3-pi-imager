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
    id: dualModeForm

    signal next()

    ColumnLayout {
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
            spacing: 12

            RowLayout {
                Layout.topMargin: -5
                ImText {
                    text: qsTr("Image version:")
                    rightPadding: 5
                }
                Item {
                    Layout.fillWidth: true
                }
                ImVersionSelector {
                    id: fieldImageVersion
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
                ImNetworkSelector {
                    id: fieldNetwork
                }

            }


            GroupBox {
                id: groupBoxExecution
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.minimumHeight: 120
                z: 0

                label: ImText {
                    text: qsTr("Execution Device")
                    Layout.topMargin: 20
                    color: "#fff"
                    horizontalAlignment: Text.AlignHCenter5
                    y: -20
                }
                background: Rectangle {
                    z: 1
                    color: "#00000000"
                    radius: 2
                    border.color: "#9affffff"
                    border.width: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10
                        anchors.margins: 15
                        anchors.bottomMargin: 10
                        anchors.topMargin: 10
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout {
                            ImText {
                                text: qsTr("Hostname:")
                                rightPadding: 5

                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            ImTextField {
                                id: fieldHostnameExecution
                                text: "eop-1-exec"
                                selectByMouse: true
                                maximumLength: 255
                                validator: RegularExpressionValidator { regularExpression: /[0-9A-Za-z][0-9A-Za-z-]{0,62}/ }
                                Layout.minimumWidth: 194
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
                                text: qsTr("Client:")
                                rightPadding: 5
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            ImComboBox {
                                id: fieldDualExecutionClient
                                selectTextByMouse: true
                                Layout.preferredWidth: 110
                                Layout.minimumHeight: 35
                                font.pointSize: 12
                                model: ListModel {
                                    ListElement { text: "Geth"; value: "geth" }
                                    ListElement { text: "Disabled"; value: "disabled" }
                                }
                                textRole: "text"
                                currentIndex: 0
                            }
                            ImText {
                                text: qsTr("Port:")
                                leftPadding: 5
                            }
                            ImTextField {
                                id: fieldDualExecutionPort
                                Layout.preferredWidth: 78
                                text: "30303"
                                font.family: roboto.name
                                font.pointSize: 12
                            }
                        }

                    }
                }

            }

            GroupBox {
                id: groupBoxExecution2
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.minimumHeight: 120
                z: 0

                label: ImText {
                    text: qsTr("Consensus Device")
                    Layout.topMargin: 20
                    color: "#fff"
                    horizontalAlignment: Text.AlignHCenter5
                    y: -20
                }
                background: Rectangle {
                    color: "transparent"
                    radius: 2
                    border.color: "#9affffff"
                    border.width: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    anchors.fill: parent
                    z: 1

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10
                        anchors.margins: 15
                        anchors.bottomMargin: 10
                        anchors.topMargin: 10
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout {
                            ImText {
                                text: qsTr("Hostname:")
                                rightPadding: 5

                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            ImTextField {
                                id: fieldHostnameConsensus
                                text: "eop-1-cons"
                                selectByMouse: true
                                maximumLength: 255
                                validator: RegularExpressionValidator { regularExpression: /[0-9A-Za-z][0-9A-Za-z-]{0,62}/ }
                                Layout.minimumWidth: 194
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
                                text: qsTr("Client:")
                                rightPadding: 5
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            ImComboBox {
                                id: fieldDualConsensusClient
                                selectTextByMouse: true
                                Layout.preferredWidth: 110
                                Layout.minimumHeight: 35
                                font.pointSize: 12
                                model: ListModel {
                                    ListElement { text: "Nimbus"; value: "nimbus" }
                                    ListElement { text: "Lighthouse"; value: "lighthouse" }
                                }
                                currentIndex: 0
                                textRole: "text"

                            }
                            ImText {
                                text: qsTr("Port:")
                                leftPadding: 5
                            }
                            ImTextField {
                                id: fieldDualConsensusPort
                                Layout.preferredWidth: 78
                                text: "9000"
                                font.family: roboto.name
                                font.pointSize: 12
                            }
                        }

                    }
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
                }
                ImCheckBox {
                    id: formatStorage
                    text: qsTr("Format storage")
                    padding: 0
                    leftPadding: 10

                }
            }
        }
        Item {
            Layout.fillWidth: true
        }
        RowLayout {
            Layout.preferredHeight: 50
            width: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ImButton {
                id: advencedbutton
                text: qsTr("Advanced")
                Layout.preferredWidth: 120
                Layout.alignment: Qt.AlignLeft
                Material.background: "#cd2355"
                Material.foreground: "#ffffff"
                onClicked: {
                    advancedSettings.screen = mainWindow.screen
                    advancedSettings.x = mainWindow.x + mainWindow.width / 2 - advancedSettings.width / 2
                    advancedSettings.y = mainWindow.y + mainWindow.height / 2 - advancedSettings.height / 2
                    advancedSettings.open()
                }
            }

            Item {
                Layout.fillWidth: true
            }

            ImButton {
                id: backbutton
                text: qsTr("Back")
                topInset: 2
                bottomInset: 2
                rightPadding: 5
                leftPadding: 5
                Layout.preferredWidth: 70
                Layout.alignment: Qt.AlignRight
                Material.background: "transparent"
                Material.foreground: "#c7ffffff"
                background: Rectangle {
                    border.color: "#c7ffffff"
                    border.width: 1
                    radius: 4
                    color: "transparent"
                }
                onClicked: {
                    stackView.pop()
                }
            }

            ImButton {
                id: continuebutton
                text: qsTr("Next")
                Layout.preferredWidth: 150
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    save()
                    next()
                }
            }
        }
    }

    function initialize(savedSettings) {
        // TODO
    }

    function save() {
        settings.hostnameExecution = fieldHostnameExecution.text
        settings.hostnameConsesnus = fieldHostnameConsensus.text
        settings.defaultNetwork = fieldNetwork.model.get(fieldNetwork.currentIndex).value
        settings.executionClient = fieldDualExecutionClient.model.get(fieldDualExecutionClient.currentIndex).value
        settings.consensusClient = fieldDualConsensusClient.model.get(fieldDualConsensusClient.currentIndex).value
        settings.executionPort = fieldDualExecutionPort.text
        settings.consensusPort = fieldDualConsensusPort.text
        settings.selectOs(fieldImageVersion.getSelectedOs())
        settings.apply()
        settings.save()
    }
}

