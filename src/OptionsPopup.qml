/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2021 Raspberry Pi Ltd
 */

import QtQuick 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import QtQuick.Window 2.15
import "qmlcomponents"

Window {
    id: popup
    minimumWidth: 520
    minimumHeight: 550

    title: qsTr("Web3 Pi Customization")

    FontLoader {id: roboto; source: "fonts/Roboto-Regular.ttf"}

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

    // Keys.onEscapePressed: {
    //     popup.close()
    // }

    ColumnLayout {
        Rectangle {
            id: bg
            implicitWidth: popup.width
            implicitHeight: popup.height

            ColumnLayout {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 30
                anchors.leftMargin: 20
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                spacing: 10

                RowLayout {
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
                        text: "exec_url=http://localhost:8551"
                        selectByMouse: true
                        Layout.minimumWidth: 220

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
                    ImTextField {
                        id: fieldWifiSSID
                        text: popup.wifiOptions.ssid
                        enabled: chkWifi.checked
                        Layout.minimumWidth: 220
                        selectByMouse: true
                        property bool indicateError: false
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
                        text: popup.wifiOptions.password
                        enabled: chkWifi.checked
                        Layout.minimumWidth: 220
                        selectByMouse: true
                        echoMode: chkShowPassword.checked ? TextInput.Normal : TextInput.Password
                        property bool indicateError: false
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
                        checked: popup.wifiOptions.ssidHidden
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
                            fieldWifiCountry.currentIndex = fieldWifiCountry.find(popup.wifiOptions.wifiCountry)
                        }
                    }
                }

                ImCheckBox {
                    id: chkOverclocking
                    text: qsTr("Raspberry Pi Overclocking")
                    checked: false
                    onCheckedChanged: {
                        if (checked) {
                            fieldOverclocking.forceActiveFocus()
                        }
                    }
                }
                ImText {
                    text: qsTr("Warning! You set this option at your own risk.\nIt may cause unstable operation or even the device may not start.")
                    color: "#555"
                    Layout.leftMargin: 34
                    Layout.topMargin: -20
                    font.pointSize: 12
                    font.italic: true
                    bottomPadding: 5
                }

                RowLayout {
                    ImText {
                        text: qsTr("CPU Ocerclock:")
                        color: chkOverclocking.checked ? "black" : "grey"
                        Layout.leftMargin: 40
                    }
                    // Spacer item
                    Item {
                        Layout.fillWidth: true
                    }
                    ComboBox {
                        id: fieldOverclocking
                        selectTextByMouse: true
                        enabled: chkOverclocking.checked
                        font.family: roboto.name
                        font.pointSize: 12
                        padding: 0
                        implicitHeight: 30
                        Layout.minimumWidth: 220
                        model: ["2500 Mhz", "2600 Mhz", "2700 Mhz", "2800 Mhz", "2900 Mhz", "3000 Mhz"]
                        Component.onCompleted: {
                            fieldOverclocking.currentIndex = fieldOverclocking.find(popup.cpuOverclock)
                        }
                    }
                }

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
                        popup.close()
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }

    }

    function openPopup() {
        show()
        raise()
    }
}
