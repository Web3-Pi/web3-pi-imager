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
                    selectTextByMouse: true
                    Layout.preferredWidth: 120
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
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ImButton {
                id: advencedbutton
                text: qsTr("Advanced")
                Layout.preferredWidth: 120
                Layout.alignment: Qt.AlignLeft
                Material.background: "#cd2355"
                Material.foreground: "#ffffff"
                onClicked: {
                    advancedSettings.screen = window.screen
                    advancedSettings.x = window.x + window.width / 2 - advancedSettings.width / 2
                    advancedSettings.y = window.y + window.height / 2 - advancedSettings.height / 2
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
                onClicked: startWritingSingleMode()
            }
        }
    }

    function initialize(savedSettings) {
        if ('hostname' in savedSettings) {
            fieldHostname.text = savedSettings.hostname
        }
        // TODO
    }

    function applySettings() {
        settings.hostname = fieldHostname.text
        settings.defaultNetwork = fieldNetwork.model.get(fieldNetwork.currentIndex).value
        console.log('EXE CLIENT', fieldExecutionClient.model.get(fieldExecutionClient.currentIndex).value)
        settings.executionClient = fieldExecutionClient.model.get(fieldExecutionClient.currentIndex).value
        settings.consensusClient = fieldConsensusClient.model.get(fieldConsensusClient.currentIndex).value
        settings.executionPort = fieldExecutionPort.text
        settings.consensusPort = fieldConsensusPort.text
        settings.selectOs(fieldImageVersion.getSelectedOs())
        settings.apply()
    }

    function startWritingSingleMode() {
        applySettings()
        settings.save()
        dstpopup.clientType = "execution"
        dstpopup.open()
    }
}

