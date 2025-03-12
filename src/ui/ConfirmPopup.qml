/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Material.impl
import "components"

Popup {
    id: msgPopup
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    width: 460
    height: msgPopupContainer.implicitHeight + 50
    padding: 0
    closePolicy: Popup.CloseOnEscape
    modal: true
    property alias text: msgPopupbody.text
    signal yes()
    signal no()

    // background of title
    Rectangle {
        id: msgPopup_title_background
        color: Material.background
        anchors.left: parent.left
        anchors.top: parent.top
        height: 35
        width: parent.width


        Text {
            id: msgPopupheader
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            // anchors.topMargin: 10
            font.family: outfit.name
            font.bold: true
            color: Material.foreground
            font.pixelSize: 16
            text: qsTr("Warning")
        }

        Text {
            text: "X"
            Layout.alignment: Qt.AlignRight
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            anchors.rightMargin: 15
            font.family: outfit.name
            font.bold: true
            font.pixelSize: 16
            color: Material.foreground

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
        color: Material.primary
        width: parent.width
        anchors.top: msgPopup_title_background.bottom
        height: 1
    }

    background: Rectangle {
        radius: Material.roundedScale
        color: Material.foreground

        border.width: 1
        border.color: Material.background

        layer.enabled: Material.elevation > 0
        layer.effect: RoundedElevationEffect {
            elevation: Material.elevation
            roundedScale: Material.roundedScale
        }
    }

    ColumnLayout {
        id: msgPopupContainer
        spacing: 20
        anchors.top: msgPopup_title_separator.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom


        Text {
            id: msgPopupbody
            font.pixelSize: 14
            font.weight: Font.Normal
            wrapMode: Text.Wrap
            textFormat: Text.StyledText
            font.family: outfit.name
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
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.alignment: Qt.AlignCenter
            ImCheckBox {
                Material.theme: Material.Light
                id: acceptTerms
                text: qsTr("I accept the ")
                padding: 0
                font.weight: Font.Medium
                font.family: outfitMedium.name
                Material.foreground: "#222"
                font.pixelSize: 14
            }
            TextInfo {
                text: "<a style='color: \"#334A4D\";font-weight: bold;' href='https://www.web3pi.io/terms'>" + qsTr("Terms of Use for Web3 Pi Software") + "</a>"
                textFormat: Text.RichText
                onLinkActivated: (link) => Qt.openUrlExternally(link)
                font.pixelSize: 14
                font.weight: Font.Bold
                font.family: dmsansBold.name
                font.italic: false
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: false
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignCenter | Qt.AlignBottom
            Layout.bottomMargin: 10
            spacing: 20
            id: buttons

            ButtonPrimary {
                text: qsTr("NO")
                onClicked: {
                    msgPopup.close()
                    msgPopup.no()
                }
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140
                font.pixelSize: 18
                Component.onCompleted: {
                    background.border.color = "#88273F43"
                    background.border.width = 1
                }
            }

            ButtonSecondary {
                text: qsTr("YES")
                onClicked: {
                    msgPopup.close()
                    msgPopup.yes()
                }
                enabled: acceptTerms.checked
                Layout.preferredHeight: 40
                Layout.preferredWidth: 140
                font.pixelSize: 18
            }
        }
    }

    function openPopup() {
        open()
        // trigger screen reader to speak out message
        msgPopupbody.forceActiveFocus()
    }
}
