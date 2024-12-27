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

    width: 560
    height: 580
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    title: qsTr("Advanced settings")

    flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint

    property bool wifiPasswordRequested: false

    Material.theme: Material.Light
    Material.foreground: "#666"

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
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            spacing: 10

            RowLayout {
                Layout.alignment: Qt.AlignCenter
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
                Item {
                    Layout.fillWidth: true
                }
                ImTextField {
                    id: fieldExecutionEndpointAddress
                    enabled: chkExecutionEndpointAddress.checked
                    selectByMouse: true
                    Layout.minimumWidth: 220
                    implicitHeight: 35
                    Layout.fillWidth: false
                }
            }

            ImCheckBox {
                id: chkLocale
                text: qsTr("Set locale settings:")
                rightPadding: 5
            }


            ColumnLayout {
                RowLayout {
                    Layout.alignment: Qt.AlignCenter

                    ImText {
                        text: qsTr("Time zone:")
                        Layout.leftMargin: 40
                        font.weight: Font.Normal
                        color: chkLocale.checked ? (fieldTimezone.indicateError ? "red" : "black") : "grey"
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ImComboBox {
                        selectTextByMouse: true
                        id: fieldTimezone
                        editable: true
                        Layout.minimumWidth: 220
                        implicitHeight: 35
                        enabled: chkLocale.checked
                        font.weight: Font.Normal
                    }
                }
                RowLayout {

                    Layout.alignment: Qt.AlignCenter
                    ImText {
                        text: qsTr("Keyboard layout:")
                        Layout.leftMargin: 40
                        font.weight: Font.Normal
                        color: chkLocale.checked ? (fieldKeyboardLayout.indicateError ? "red" : "black") : "grey"
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ImComboBox {
                        id: fieldKeyboardLayout
                        selectTextByMouse: true
                        editable: true
                        Layout.minimumWidth: 220
                        implicitHeight: 35
                        enabled: chkLocale.checked
                        font.weight: Font.Normal
                    }
                }

            }

            ImCheckBox {
                id: chkWifi
                text: qsTr("Configure wireless LAN")
                onCheckedChanged: {
                    if (checked) {
                        if (!wifiPasswordRequested) {
                            if (!fieldWifiPassword.text.length && advancedSettings.visible) {
                                fieldWifiPassword.text = imageWriter.getPSK()
                                wifiPasswordRequested = true
                            }
                        }
                        if (!fieldWifiSSID.length) {
                            fieldWifiSSID.forceActiveFocus()
                        } else if (!fieldWifiPassword.length) {
                            fieldWifiPassword.forceActiveFocus()
                        }
                    }
                }
            }
            ImText {
                text: qsTr("We recommend using an ethernet cable")
                color: "#555"
                font.weight: Font.Normal
                Layout.leftMargin: 25
                Layout.topMargin: -16
                font.pixelSize: 14
                font.italic: true
            }

            RowLayout {
                ImText {
                    text: qsTr("SSID:")
                    color: chkWifi.checked ? (fieldWifiSSID.indicateError ? "red" : "black") : "grey"
                    Layout.leftMargin: 40
                    font.weight: Font.Normal
                }
                Item {
                    Layout.fillWidth: true
                }
                ImTextField {
                    id: fieldWifiSSID
                    enabled: chkWifi.checked
                    Layout.preferredWidth: 220
                    Layout.fillWidth: false
                    selectByMouse: true
                    property bool indicateError: false
                    implicitHeight: 35
                    onTextEdited: {
                        indicateError = false
                    }
                    font.weight: Font.Normal
                }
            }
            RowLayout {
                ImText {
                    text: qsTr("Password:")
                    color: chkWifi.checked ? (fieldWifiPassword.indicateError ? "red" : "black") : "grey"
                    Layout.leftMargin: 40
                    font.weight: Font.Normal
                }
                Item {
                    Layout.fillWidth: true
                }
                ImTextField {
                    id: fieldWifiPassword
                    enabled: chkWifi.checked
                    Layout.preferredWidth: 220
                    selectByMouse: true
                    Layout.fillWidth: false
                    echoMode: chkShowPassword.checked ? TextInput.Normal : TextInput.Password
                    property bool indicateError: false
                    implicitHeight: 35
                    font.weight: Font.Normal
                    onTextEdited: {
                        indicateError = false
                    }
                }
            }

            RowLayout {
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
                    Material.foreground: "#000"
                }
                Item {
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                ImText {
                    text: qsTr("Wireless LAN country:")
                    color: chkWifi.checked ? "black" : "grey"
                    Layout.leftMargin: 40
                    font.weight: Font.Normal
                }
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                ImComboBox {
                    id: fieldWifiCountry
                    selectTextByMouse: true
                    enabled: chkWifi.checked
                    editable: true
                    implicitHeight: 35
                    Layout.minimumWidth: 220
                    font.weight: Font.Normal
                }
            }

        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            id: buttonsRow
            Layout.alignment: Qt.AlignCenter

            Item {
                Layout.fillWidth: true
            }

            ButtonSecondary {
                text: qsTr("SAVE")
                Layout.preferredWidth: 150
                onClicked: {
                    validate()
                    save()
                    advancedSettings.close()
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

    }

    function validate(): bool {
        let error = false;
        if (chkExecutionEndpointAddress.checked && fieldExecutionEndpointAddress.text.length == 0) {
            fieldExecutionEndpointAddress.indicateError = true
            fieldExecutionEndpointAddress.forceActiveFocus()
            error = true
        }

        if (chkWifi.checked) {
            // Valid Wi-Fi PSKs are:
            // - 0 characters (indicating an open network)
            // - 8-63 characters (passphrase)
            // - 64 characters (hashed passphrase, as hex)
            if (fieldWifiPassword.text.length > 0 &&
                (fieldWifiPassword.text.length < 8 || fieldWifiPassword.text.length > 64)) {
                fieldWifiPassword.indicateError = true
                fieldWifiPassword.forceActiveFocus()
                error = true
            }
            if (fieldWifiSSID.text.length == 0) {
                fieldWifiSSID.indicateError = true
                fieldWifiSSID.forceActiveFocus()
                error = true
            }
        }

        return !!error
    }

    function initialize() {
        chkExecutionEndpointAddress.checked = settings.executionEndpointAddressChecked
        fieldExecutionEndpointAddress.text = settings.executionEndpointAddress

        fieldTimezone.model = imageWriter.getTimezoneList()
        fieldKeyboardLayout.model = imageWriter.getKeymapLayoutList()
        fieldWifiCountry.model = imageWriter.getCountryList()

        fieldWifiSSID.text = settings.wifiOptions.ssid
        chkWifiSSIDHidden.checked = settings.wifiOptions.ssidHidden
        fieldWifiPassword.text = settings.wifiOptions.password
        fieldWifiCountry.currentIndex = fieldWifiCountry.find(settings.wifiOptions.wifiCountry)
        if (fieldWifiCountry.currentIndex === -1) {
            fieldWifiCountry.editText = settings.wifiOptions.wifiCountry
        }
        chkWifi.checked = settings.wifiOptions.checked

        chkLocale.checked = settings.localeOptions.checked
        fieldKeyboardLayout.currentIndex = fieldKeyboardLayout.find(settings.localeOptions.keyboardLayout)
        if (fieldKeyboardLayout.currentIndex === -1) {
            fieldKeyboardLayout.editText = settings.localeOptions.keyboardLayout
        }

        fieldTimezone.currentIndex = fieldTimezone.find(settings.localeOptions.timezone)
        if (fieldTimezone.currentIndex === -1) {
            fieldTimezone.editText = settings.localeOptions.timezone
        }
    }

    function save() {
        settings.executionEndpointAddressChecked = chkExecutionEndpointAddress.checked
        settings.executionEndpointAddress = fieldExecutionEndpointAddress.text
        settings.localeOptions.checked = chkLocale.checked
        settings.localeOptions.timezone = fieldTimezone.editText
        settings.localeOptions.keyboardLayout = fieldKeyboardLayout.editText
        settings.wifiOptions.checked = chkWifi.checked
        settings.wifiOptions.ssid = fieldWifiSSID.text
        settings.wifiOptions.password = fieldWifiPassword.text
        settings.wifiOptions.hidden = chkWifiSSIDHidden.checked
        settings.wifiOptions.country = fieldWifiCountry.currentText

        settings.save()
    }

    function open() {
        show()
        raise()
    }
}
