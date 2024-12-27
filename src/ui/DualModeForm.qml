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
        anchors.topMargin: 0
        anchors.bottomMargin: 40
        anchors.fill: parent


        RowLayout {
            width: parent.width
            spacing: 15

            ColumnLayout {
                Layout.preferredWidth: parent.width / 2 - 7
                spacing: 30
                ColumnLayout {
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("Image version:")
                    }
                    ImVersionSelector {
                        id: fieldImageVersion
                    }
                }

                Rectangle {
                    color: "#334A4D"
                    radius: 9
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.margins: 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: 240

                    Item {
                        anchors.fill: parent
                        anchors.margins: 20

                        RowLayout {
                            anchors.fill: parent
                            ColumnLayout {
                                spacing: 20
                                Label {
                                    text: qsTr("Execution device")
                                    Layout.topMargin: -15
                                }
                                ColumnLayout {
                                    Label {
                                        text: qsTr("Hostname:")
                                        font.pixelSize: 16
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        ImTextField {
                                            id: fieldHostnameExecution
                                            text: "eop-1-exec"
                                            maximumLength: 255
                                            Layout.fillWidth: false
                                            Layout.preferredWidth: 220
                                            validator: RegularExpressionValidator { regularExpression: /[0-9A-Za-z][0-9A-Za-z-]{0,62}/ }

                                        }
                                        ImText {
                                            text : ".local"
                                        }
                                    }
                                }


                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 25
                                    ColumnLayout {
                                        Label {
                                            text: qsTr("Client:")
                                            font.pixelSize: 16
                                        }
                                        ImComboBox {
                                            id: fieldDualExecutionClient
                                            Layout.preferredWidth: 140
                                            model: ListModel {
                                                ListElement { text: "Geth"; value: "geth" }
                                                ListElement { text: "Disabled"; value: "disabled" }
                                            }
                                            textRole: "text"
                                            currentIndex: 0
                                        }
                                    }
                                    ColumnLayout {
                                        Label {
                                            text: qsTr("Port:")
                                            font.pixelSize: 16
                                        }
                                        ImTextField {
                                            id: fieldDualExecutionPort
                                            Layout.preferredWidth: 100
                                            Layout.fillWidth: false
                                            text: "30303"
                                        }

                                    }
                                }

                            }

                        }
                    }

                }


                ImCheckBox {
                    id: monitoring
                    checked: true
                    text: qsTr("Enable Grafana monitoring")
                }
            }

            ColumnLayout {
                Layout.preferredWidth: parent.width / 2 - 7
                spacing: 30
                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        text: qsTr("Default Network:")
                    }
                    ImNetworkSelector {
                        id: fieldNetwork
                        currentIndex: 0
                    }
                }

                Rectangle {
                    color: "#334A4D"
                    radius: 9
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.margins: 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: 240

                    Item {
                        anchors.fill: parent
                        anchors.margins: 20

                        RowLayout {
                            anchors.fill: parent
                            ColumnLayout {
                                spacing: 20
                                Label {
                                    text: qsTr("Consesnus device")
                                    Layout.topMargin: -15
                                }
                                ColumnLayout {
                                    Label {
                                        text: qsTr("Hostname:")
                                        font.pixelSize: 16
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        ImTextField {
                                            id: fieldHostnameConsensus
                                            text: "eop-1-cons"
                                            maximumLength: 255
                                            Layout.fillWidth: false
                                            Layout.preferredWidth: 220
                                            validator: RegularExpressionValidator { regularExpression: /[0-9A-Za-z][0-9A-Za-z-]{0,62}/ }

                                        }
                                        ImText {
                                            text : ".local"
                                        }
                                    }
                                }


                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 25
                                    ColumnLayout {
                                        Label {
                                            text: qsTr("Client:")
                                            font.pixelSize: 16
                                        }
                                        ImComboBox {
                                            id: fieldDualConsensusClient
                                            selectTextByMouse: true
                                            Layout.preferredWidth: 140
                                            model: ListModel {
                                                ListElement { text: "Nimbus"; value: "nimbus" }
                                                ListElement { text: "Lighthouse"; value: "lighthouse" }
                                                ListElement { text: "Disabled"; value: "disabled" }
                                            }
                                            currentIndex: 0
                                            textRole: "text"
                                        }
                                    }
                                    ColumnLayout {
                                        Label {
                                            text: qsTr("Port:")
                                            font.pixelSize: 16
                                        }
                                        ImTextField {
                                            id: fieldDualConsensusPort
                                            text: "9000"
                                            Layout.fillWidth: false
                                            Layout.preferredWidth: 100
                                        }

                                    }
                                }

                            }

                        }
                    }

                }

                ImCheckBox {
                    id: formatStorage
                    text: qsTr("Format storage")
                    Material.foreground: "#ffffff"
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }
        RowLayout {
            width: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ButtonSecondary {
                text: qsTr("ADVANCED")
                Layout.preferredWidth: 152
                Layout.alignment: Qt.AlignLeft
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

            ButtonOutline {
                text: qsTr("BACK")
                Layout.rightMargin: 10
                Layout.preferredWidth: 87
                onClicked: {
                    stackView.pop()
                    versionManager.fetchOSList();
                }
            }

            ButtonPrimary {
                text: qsTr("NEXT")
                Layout.preferredWidth: 187
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    save()
                    next()
                }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        onEntered: (drag, mimeData) => {
            if (drag.active && mimeData.hasUrls()) {
                drag.acceptProposedAction()
            }
        }
        onDropped: (drop) => {
            if (drop.urls && drop.urls.length > 0) {
                versionManager.onFileSelected(drop.urls[0].toString())
                fieldImageVersion.currentIndex = fieldImageVersion.model.count - 1
            }
        }
    }

    function findIndexByValue(model, role, value) {
        for (let i = 0; i < model.count; i++) {
            if (model.get(i)[role] === value) {
                return i;
            }
        }
        return -1;
    }

    function initialize() {
        fieldHostnameExecution.text = settings.hostnameExecution
        fieldHostnameConsensus.text = settings.hostnameConsesnus
        fieldNetwork.currentIndex = findIndexByValue(fieldNetwork.model, "value", settings.defaultNetwork)
        fieldDualExecutionClient.currentIndex = findIndexByValue(fieldDualExecutionClient.model, "value", settings.executionClient)
        fieldDualConsensusClient.currentIndex = findIndexByValue(fieldDualConsensusClient.model, "value", settings.consensusClient)
        fieldDualExecutionPort.text = settings.executionPort
        fieldDualConsensusPort.text = settings.consensusPort
        monitoring.checked = settings.monitoring
        formatStorage.checked = settings.formatStorage
    }

    function save() {
        settings.hostnameExecution = fieldHostnameExecution.text
        settings.hostnameConsesnus = fieldHostnameConsensus.text
        settings.defaultNetwork = fieldNetwork.model.get(fieldNetwork.currentIndex).value
        settings.executionClient = fieldDualExecutionClient.model.get(fieldDualExecutionClient.currentIndex).value
        settings.consensusClient = fieldDualConsensusClient.model.get(fieldDualConsensusClient.currentIndex).value
        settings.executionPort = fieldDualExecutionPort.text
        settings.consensusPort = fieldDualConsensusPort.text
        settings.monitoring = monitoring.checked
        settings.formatStorage = formatStorage.checked
        settings.selectOs(fieldImageVersion.getSelectedOs())
        settings.apply()
        settings.save()
    }
}



