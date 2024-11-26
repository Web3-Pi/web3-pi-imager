/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2021 Raspberry Pi Ltd
 */

import QtQuick 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import QtQuick.Window 2.15
import "components"

Window {
    id: advancedSettings

    width: 540
    height: 620
    minimumWidth: 540
    minimumHeight: 620

    title: qsTr("Advanced settings")

    FontLoader {id: roboto; source: "fonts/Roboto-Regular.ttf"}

    Material.theme: Material.Light

    property var wifiOptions: {
        "checked": chkWifi.checked,
        "ssid": fieldWifiSSID.text,
        "password": fieldWifiPassword.text,
        "ssidHidden": chkWifiSSIDHidden.checked,
        "wifiCountry": fieldWifiCountry.currentText
    }

    property var executionEndpointAddress: {
        "checked": chkExecutionEndpointAddress.checked,
        "value": fieldExecutionEndpointAddress.text
    }
    property var cpuOverclock: {
        "checked": chkOverclocking.checked,
        "value": fieldOverclocking.currentText
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.bottomMargin: 35
        anchors.topMargin: 35
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            anchors.top: parent.top
            spacing: 10

            RowLayout {
                anchors.right: parent.right
                anchors.left: parent.left
                spacing: 10
                ImCheckBox {
                    id: chkExecutionEndpointAddress
                    text: qsTr("Execution endpoint address:")
                    onCheckedChanged: {
                        if (checked) {
                            fieldExecutionEndpointAddress.forceActiveFocus()
                        }
                    }
                }
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                TextField {
                    id: fieldExecutionEndpointAddress
                    enabled: chkExecutionEndpointAddress.checked
                    text: "exec_url=http://localhost:8551"
                    selectByMouse: true
                    Layout.minimumWidth: 220
                    font.pointSize: 14
                    padding: 0
                    implicitHeight: 35
                }
            }

            ImCheckBox {
                id: chkLocale
                text: qsTr("Set locale settings:")
                rightPadding: 5
            }


            ColumnLayout {
                RowLayout {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    ImText {
                        text: qsTr("Time zone:")
                        Layout.leftMargin: 40
                        color: chkLocale.checked ? (fieldTimezone.indicateError ? "red" : "black") : "grey"
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ComboBox {
                        selectTextByMouse: true
                        id: fieldTimezone
                        editable: true
                        Layout.minimumWidth: 220
                        font.pointSize: 12
                        font.family: roboto.name
                        padding: 0
                        implicitHeight: 35
                    }
                }
                RowLayout {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    ImText {
                        text: qsTr("Keyboard layout:")
                        Layout.leftMargin: 40
                        color: chkLocale.checked ? (fieldKeyboardLayout.indicateError ? "red" : "black") : "grey"
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ComboBox {
                        selectTextByMouse: true
                        id: fieldKeyboardLayout
                        editable: true
                        Layout.minimumWidth: 220
                        font.pointSize: 12
                        font.family: roboto.name
                        padding: 0
                        implicitHeight: 35
                        model: ["en", "gb"]
                    }
                }

            }

            ImCheckBox {
                id: chkWifi
                text: qsTr("Configure wireless LAN")
                onCheckedChanged: {
                    if (checked) {
                        if (!fieldWifiSSID.length) {
                            fieldWifiSSID.forceActiveFocus()
                        } else if (!fieldWifiPassword.length) {
                            fieldWifiPassword.forceActiveFocus()
                        }
                    }
                }
            }
            ImText {
                text: qsTr("We strongly recommend using an ethernet cable")
                color: "#555"
                Layout.leftMargin: 34
                Layout.topMargin: -20
                font.pointSize: 12
                font.italic: true
            }

            RowLayout {
                ImText {
                    text: qsTr("SSID:")
                    color: chkWifi.checked ? (fieldWifiSSID.indicateError ? "red" : "black") : "grey"
                    Layout.leftMargin: 40
                }
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                TextField {
                    id: fieldWifiSSID
                    text: advancedSettings.wifiOptions.ssid
                    enabled: chkWifi.checked
                    Layout.minimumWidth: 220
                    selectByMouse: true
                    property bool indicateError: false
                    font.pointSize: 14
                    padding: 0
                    implicitHeight: 35
                    onTextEdited: {
                        indicateError = false
                    }
                }
            }
            RowLayout {
                ImText {
                    text: qsTr("Password:")
                    color: chkWifi.checked ? (fieldWifiPassword.indicateError ? "red" : "black") : "grey"
                    Layout.leftMargin: 40
                }
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                TextField {
                    id: fieldWifiPassword
                    text: advancedSettings.wifiOptions.password
                    enabled: chkWifi.checked
                    Layout.minimumWidth: 220
                    selectByMouse: true
                    echoMode: chkShowPassword.checked ? TextInput.Normal : TextInput.Password
                    property bool indicateError: false
                    font.pointSize: 14
                    padding: 0
                    implicitHeight: 35
                    onTextEdited: {
                        indicateError = false
                    }
                }
            }

            RowLayout {
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                ImCheckBox {
                    id: chkShowPassword
                    enabled: chkWifi.checked
                    text: qsTr("Show password")
                    checked: true
                }
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                ImCheckBox {
                    id: chkWifiSSIDHidden
                    enabled: chkWifi.checked
                    Layout.columnSpan: 2
                    text: qsTr("Hidden SSID")
                    checked: advancedSettings.wifiOptions.ssidHidden
                }
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                ImText {
                    text: qsTr("Wireless LAN country:")
                    color: chkWifi.checked ? "black" : "grey"
                    Layout.leftMargin: 40
                }
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                ComboBox {
                    id: fieldWifiCountry
                    model: imageWriter.getCountryList()
                    selectTextByMouse: true
                    enabled: chkWifi.checked
                    editable: true
                    font.family: roboto.name
                    font.pointSize: 12
                    padding: 0
                    implicitHeight: 35
                    Layout.minimumWidth: 220
                    Component.onCompleted: {
                        fieldWifiCountry.currentIndex = fieldWifiCountry.find(advancedSettings.wifiOptions.wifiCountry)
                    }
                }
            }



        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            id: buttonsRow
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            Item {
                Layout.fillWidth: true
            }

            ImButtonRed {
                text: qsTr("SAVE")
                Layout.preferredWidth: 150
                onClicked: {
                    if (chkExecutionEndpointAddress.checked && fieldExecutionEndpointAddress.text.length == 0)
                    {
                        fieldExecutionEndpointAddress.indicateError = true
                        fieldExecutionEndpointAddress.forceActiveFocus()
                        return
                    }

                    if (chkWifi.checked)
                    {
                        // Valid Wi-Fi PSKs are:
                        // - 0 characters (indicating an open network)
                        // - 8-63 characters (passphrase)
                        // - 64 characters (hashed passphrase, as hex)
                        if (fieldWifiPassword.text.length > 0 &&
                            (fieldWifiPassword.text.length < 8 || fieldWifiPassword.text.length > 64))
                        {
                            fieldWifiPassword.indicateError = true
                            fieldWifiPassword.forceActiveFocus()
                        }
                        if (fieldWifiSSID.text.length == 0)
                        {
                            fieldWifiSSID.indicateError = true
                            fieldWifiSSID.forceActiveFocus()
                        }
                    }
                    advancedSettings.close()
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

    }

    function open() {
        show()
        raise()
    }
}
