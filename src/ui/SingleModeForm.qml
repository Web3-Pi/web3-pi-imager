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
    id: singleModeForm

    signal next()

    ColumnLayout {
        id: mainForm
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 0
        anchors.bottomMargin: 40
        anchors.fill: parent


        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 30

            ColumnLayout {
                Layout.topMargin: -20
                Label {
                    text: qsTr("Image version:")
                }
                ImVersionSelector {
                    id: fieldImageVersion
                }
            }

            RowLayout {
                width: parent.width
                spacing: 15

                ColumnLayout {
                    Layout.preferredWidth: parent.width / 2
                    spacing: 25
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            text: qsTr("Default Network:")
                        }
                        ImNetworkSelector {
                            id: fieldNetwork
                        }
                    }
                    Rectangle {
                        color: "#334A4D"
                        radius: 9
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.margins: 0
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120

                        Item {
                            anchors.fill: parent
                            anchors.margins: 20

                            RowLayout {
                                anchors.fill: parent
                                spacing: 15
                                ColumnLayout {
                                    Label {
                                        text: qsTr("Execution client:")
                                        font.pixelSize: 16
                                    }
                                    ImComboBox {
                                        id: fieldExecutionClient
                                        Layout.preferredWidth: 130
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
                                        id: fieldExecutionPort
                                        Layout.preferredWidth: 90
                                        Layout.fillWidth: false
                                        text: "30303"
                                    }

                                }
                            }
                        }
                    }

                    ImCheckBox {
                        id: monitoring
                        checked: true
                        font.weight: Font.Medium
                        font.family: outfitMedium.name
                        text: qsTr("Enable Grafana monitoring")
                    }
                }


                ColumnLayout {
                    Layout.preferredWidth: parent.width / 2
                    spacing: 25
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            text: qsTr("Hostname:")
                        }
                        RowLayout {
                            ImTextField {
                                id: fieldHostname
                                text: "eop-1"
                                maximumLength: 255
                                validator: RegularExpressionValidator { regularExpression: /[0-9A-Za-z][0-9A-Za-z-]{0,62}/ }

                            }
                            ImText {
                                text : ".local"
                            }
                        }

                    }

                    Rectangle {
                        color: "#334A4D"
                        radius: 9
                        Layout.margins: 0
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120

                        Item {
                            anchors.fill: parent
                            anchors.margins: 20
                            anchors.topMargin: 15

                            RowLayout {
                                anchors.fill: parent
                                spacing: 15
                                ColumnLayout {
                                    Label {
                                        text: qsTr("Consesnus client:")
                                        font.pixelSize: 16
                                    }
                                    ImComboBox {
                                        id: fieldConsensusClient
                                        selectTextByMouse: true
                                        Layout.preferredWidth: 130
                                        model: ListModel {
                                            ListElement { text: "Nimbus"; value: "nimbus" }
                                            ListElement { text: "Lighthouse"; value: "lighthouse" }
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
                                        id: fieldConsensusPort
                                        text: "9000"
                                        Layout.fillWidth: false
                                        Layout.preferredWidth: 90
                                    }

                                }
                            }
                        }

                    }

                    ImCheckBox {
                        id: formatStorage
                        text: qsTr("Format storage")
                        padding: 0
                        font.weight: Font.Medium
                        font.family: outfitMedium.name
                        Material.foreground: "#ffffff"
                    }
                }
            }
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

    function initialize(savedSettings) {
        if ('hostname' in savedSettings) {
            fieldHostname.text = savedSettings.hostname
        }
        // TODO
    }

    function save() {
        settings.hostname = fieldHostname.text
        settings.defaultNetwork = fieldNetwork.model.get(fieldNetwork.currentIndex).value
        settings.executionClient = fieldExecutionClient.model.get(fieldExecutionClient.currentIndex).value
        settings.consensusClient = fieldConsensusClient.model.get(fieldConsensusClient.currentIndex).value
        settings.executionPort = fieldExecutionPort.text
        settings.consensusPort = fieldConsensusPort.text
        settings.monitoring = monitoring.checked
        settings.formatStorage = formatStorage.checked
        settings.selectOs(fieldImageVersion.getSelectedOs())
        settings.apply()
        settings.save()
    }
}
