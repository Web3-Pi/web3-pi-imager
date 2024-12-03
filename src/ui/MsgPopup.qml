/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
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
    width: 460
    height: msgPopupbody.implicitHeight+150
    padding: 0
    closePolicy: Popup.CloseOnEscape
    modal: true

    property alias title: msgPopupheader.text
    property alias text: msgPopupbody.text
    property bool continueButton: true
    property bool quitButton: false
    property bool yesButton: false
    property bool noButton: false
    signal yes()
    signal no()

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
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Accessible.name: text.replace(/<\/?[^>]+(>|$)/g, "")
        }

        RowLayout {
            Layout.alignment: Qt.AlignCenter | Qt.AlignBottom
            Layout.bottomMargin: 10
            spacing: 20
            id: buttons

            ImButtonRed {
                text: qsTr("NO")
                onClicked: {
                    msgPopup.close()
                    msgPopup.no()
                }
                visible: msgPopup.noButton
            }

            ImButtonRed {
                text: qsTr("YES")
                onClicked: {
                    msgPopup.close()
                    msgPopup.yes()
                }
                visible: msgPopup.yesButton
            }

            ImButtonRed {
                text: qsTr("CONTINUE")
                onClicked: {
                    msgPopup.close()
                }
                visible: msgPopup.continueButton
            }

            ImButtonRed {
                text: qsTr("QUIT")
                onClicked: {
                    Qt.quit()
                }
                font.family: roboto.name
                visible: msgPopup.quitButton
            }
        }
    }

    function openPopup() {
        open()
        // trigger screen reader to speak out message
        msgPopupbody.forceActiveFocus()
    }
}
