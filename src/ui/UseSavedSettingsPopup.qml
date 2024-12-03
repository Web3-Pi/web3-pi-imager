/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2021 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
import "components"

Popup {
    id: msgPopup
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    width: 550
    height: msgPopupbody.implicitHeight+150
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    modal: true

    property bool hasSavedSettings: false

    signal yes()
    signal no()
    signal noClearSettings()
    signal editSettings()
    signal closeSettings()

    // background of title
    Rectangle {
        id: msgPopup_title_background
        color: "#f5f5f5"
        anchors.left: parent.left
        anchors.top: parent.top
        height: 35
        width: parent.width

        Text {
            id: msgPopupheader
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            anchors.topMargin: 10
            font.family: roboto.name
            font.bold: true
            text: qsTr("Use OS customization?")
        }

        Text {
            text: "X"
            Layout.alignment: Qt.AlignRight
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 25
            anchors.topMargin: 10
            font.family: roboto.name
            font.bold: true

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    msgPopup.close()
                }
            }
        }
    }
    // line under title
    Rectangle {
        id: msgPopup_title_separator
        color: "#afafaf"
        width: parent.width
        anchors.top: msgPopup_title_background.bottom
        height: 1
    }

    ColumnLayout {
        spacing: 20
        anchors.top: msgPopup_title_separator.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Text {
            id: msgPopupbody
            font.pointSize: 12
            wrapMode: Text.Wrap
            textFormat: Text.StyledText
            font.family: roboto.name
            Layout.fillHeight: true
            Layout.leftMargin: 25
            Layout.rightMargin: 25
            Layout.topMargin: 25
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Accessible.name: text.replace(/<\/?[^>]+(>|$)/g, "")
            text: qsTr("Would you like to apply OS customization settings?")
        }

        RowLayout {
            Layout.alignment: Qt.AlignCenter | Qt.AlignBottom
            Layout.bottomMargin: 10
            id: buttons

            ImButtonRed {
                text: qsTr("EDIT SETTINGS")
                onClicked: {
                    // Don't close this dialog when "edit settings" is
                    // clicked, as we don't want the user to fall back to the
                    // start of the flow. After editing the settings we want
                    // then to once again have the choice about whether to use
                    // customisation or not.
                    msgPopup.editSettings()
                }
            }

            ImButtonRed {
                id: noAndClearButton
                text: qsTr("NO, CLEAR SETTINGS")
                onClicked: {
                    msgPopup.close()
                    msgPopup.noClearSettings()
                }
                enabled: hasSavedSettings
            }

            ImButtonRed {
                id: yesButton
                text: qsTr("YES")
                onClicked: {
                    msgPopup.close()
                    msgPopup.yes()
                }
                enabled: hasSavedSettings
            }

            ImButtonRed {
                text: qsTr("NO")
                onClicked: {
                    msgPopup.close()
                    msgPopup.no()
                }
            }
        }
    }

    function openPopup() {
        open()
        if (imageWriter.hasSavedCustomizationSettings()) {
            /* HACK: Bizarrely, the button enabled characteristics are not re-evaluated on open.
             * So, let's manually _force_ these buttons to be enabled */
            hasSavedSettings = true
        }

        // trigger screen reader to speak out message
        msgPopupbody.forceActiveFocus()
    }

    onClosed: {
        // Close the advanced options mainWindow if this msgbox is dismissed,
        // in order to prevent the user from starting writing while the
        // advanced options mainWindow is open.
        closeSettings()
    }
}
