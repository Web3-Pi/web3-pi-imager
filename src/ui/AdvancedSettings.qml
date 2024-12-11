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
    minimumWidth: 560
    minimumHeight: 620

    title: qsTr("Advanced settings")

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
                // Spacer item
                Item {
                    Layout.fillWidth: true
                }
                ImTextField {
                    id: fieldExecutionEndpointAddress
                    enabled: chkExecutionEndpointAddress.checked
                    text: "http://localhost:8551"
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
                    }
                }
                RowLayout {

                    Layout.alignment: Qt.AlignCenter
                    ImText {
                        text: qsTr("Keyboard layout:")
                        Layout.leftMargin: 40
                        color: chkLocale.checked ? (fieldKeyboardLayout.indicateError ? "red" : "black") : "grey"
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ImComboBox {
                        id: fieldKeyboardLayout
                        // Material.foreground: "#000"
                        selectTextByMouse: true
                        editable: true
                        Layout.minimumWidth: 220
                        implicitHeight: 35
                        model: ["en", "gb"]
                        enabled: chkLocale.checked
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
                text: qsTr("We recommend using an ethernet cable")
                color: "#555"
                Layout.leftMargin: 25
                Layout.topMargin: -16
                font.pointSize: 14
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
                ImTextField {
                    id: fieldWifiPassword
                    enabled: chkWifi.checked
                    Layout.preferredWidth: 220
                    selectByMouse: true
                    Layout.fillWidth: false
                    echoMode: chkShowPassword.checked ? TextInput.Normal : TextInput.Password
                    property bool indicateError: false
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
                    Material.foreground: "#000"
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
                ImComboBox {
                    id: fieldWifiCountry
                    model: imageWriter.getCountryList()
                    selectTextByMouse: true
                    enabled: chkWifi.checked
                    editable: true
                    implicitHeight: 35
                    Layout.minimumWidth: 220
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
                    // TODO
                    // if (validate()) {
                    //     advancedSettings.close()
                    // }
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

    function initialize(savedSettings) {
        fieldTimezone.model = imageWriter.getTimezoneList()
        fieldKeyboardLayout.model = imageWriter.getKeymapLayoutList()

        if ('wifiSSID' in savedSettings) {
            fieldWifiSSID.text = savedSettings.wifiSSID
            if ('wifiSSIDHidden' in savedSettings && savedSettings.wifiSSIDHidden) {
                chkWifiSSIDHidden.checked = true
            }
            fieldWifiPassword.text = savedSettings.wifiPassword
            fieldWifiCountry.currentIndex = fieldWifiCountry.find(savedSettings.wifiCountry)
            if (fieldWifiCountry.currentIndex == -1) {
                fieldWifiCountry.editText = savedSettings.wifiCountry
            }
            chkWifi.checked = true
        } else {
            fieldWifiCountry.currentIndex = fieldWifiCountry.find("GB")
            fieldWifiSSID.text = imageWriter.getSSID()
            if (fieldWifiSSID.text.length) {
                fieldWifiPassword.text = imageWriter.getPSK()
                if (fieldWifiPassword.text.length) {
                    chkShowPassword.checked = false
                    if (Qt.platform.os == "osx") {
                        /* User indicated wifi must be prefilled */
                        chkWifi.checked = true
                    }
                }
            }
        }

        var tz;
        if ('timezone' in savedSettings) {
            chkLocale.checked = true
            tz = savedSettings.timezone
        } else {
            tz = imageWriter.getTimezone()
        }
        var tzidx = fieldTimezone.find(tz)
        if (tzidx === -1) {
            fieldTimezone.editText = tz
        } else {
            fieldTimezone.currentIndex = tzidx
        }
        if ('keyboardLayout' in savedSettings) {
            fieldKeyboardLayout.currentIndex = fieldKeyboardLayout.find(savedSettings.keyboardLayout)
            if (fieldKeyboardLayout.currentIndex == -1) {
                fieldKeyboardLayout.editText = savedSettings.keyboardLayout
            }
        } else {
            if (imageWriter.isEmbeddedMode())
            {
                fieldKeyboardLayout.currentIndex = fieldKeyboardLayout.find(imageWriter.getCurrentKeyboard())
            }
            else
            {
                /* Lacking an easy cross-platform to fetch keyboard layout
                   from host system, just default to "gb" for people in
                   UK time zone for now, and "us" for everyone else */
                if (tz === "Europe/London") {
                    fieldKeyboardLayout.currentIndex = fieldKeyboardLayout.find("gb")
                } else {
                    fieldKeyboardLayout.currentIndex = fieldKeyboardLayout.find("us")
                }
            }
        }
    }

    function save() {
        if (chkExecutionEndpointAddress.checked) {
            settings.executionEndpointAddress = fieldExecutionEndpointAddress.text
        }
        if (chkLocale.checked) {
            settings.localeOptions.checked = true
            settings.localeOptions.timezone = fieldTimezone.editText
            settings.localeOptions.keyboardLayout = fieldKeyboardLayout.editText
        }
        if (chkWifi.checked) {
            settings.wifiOptions.checked = true
            settings.wifiOptions.ssid = fieldWifiSSID.text
            settings.wifiOptions.password = fieldWifiPassword.text
            settings.wifiOptions.hidden = chkWifiSSIDHidden.checked
            settings.wifiOptions.country = fieldWifiCountry.currentText
        }
    }

    function open() {
        show()
        raise()
    }
}
