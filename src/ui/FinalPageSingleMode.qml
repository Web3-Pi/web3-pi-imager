/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Material.impl
import "components"
Item {
    id: finalPageSingleMode
    property bool success: true

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.rightMargin: 35
        anchors.leftMargin: 35
        anchors.topMargin: 10
        anchors.bottomMargin: 35
        anchors.fill: parent

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 25
            Layout.topMargin: 50

            ColumnLayout {
                id: successInfo
                visible: true
                Layout.alignment: Qt.AlignCenter
                spacing: 30
                Layout.topMargin: 5


                Item {
                    width: 82
                    height: 105
                    Layout.alignment: Qt.AlignHCenter
                    Image {
                        anchors.fill: parent
                        source: "icons/success.png"
                        Layout.alignment: Qt.AlignCenter
                    }
                }

                ImText {
                    visible: !finalPageSingleMode.success
                    Layout.topMargin: 20
                    text: "If you wish to perform installation on your device later,\nplease refer to our documentation"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignCenter
                    font.weight: Font.Medium
                    Layout.bottomMargin: 45
                }

                ImText {
                    visible: finalPageSingleMode.success
                    Layout.topMargin: 20
                    text: "Installation process has begun..."
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignCenter
                    font.weight: Font.Medium

                }

                ButtonPrimary {
                    visible: finalPageSingleMode.success
                    Layout.preferredWidth: 187
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("TRACK")
                    onClicked: {
                        Qt.openUrlExternally(`http://${settings.hostname}.local`)
                    }
                    Layout.bottomMargin: 25
                }



                ColumnLayout {
                    Layout.alignment: Qt.AlignCenter
                    spacing: 10

                    ImText {
                        text: qsTr("Monitor installation process at: <a href='http://%1.local' style='color: white;'>http://%1.local</a>").arg(settings.hostname)
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: false
                        }
                    }

                    ImText {
                        text: "Log in via SSH using credentials: <span style='color: white;'>ethereum:ethereum</span>"
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                    }

                    ImText {
                        text: qsTr("More information at: <a href='https://www.web3pi.io' style='color: white;'>www.web3pi.io</a>")
                        textFormat: Text.RichText
                        color: "#99ffffff"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: false
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 20

            ButtonOutline {
                id: backButton
                visible: !finalPageSingleMode.success
                Layout.preferredWidth: 152
                Layout.alignment: Qt.AlignCenter
                text: qsTr("BACK")
                onClicked: {
                    stackView.pop()
                    hostResolverPage.startResolving();
                }
            }

            ButtonPrimary {
                id: finishButton
                visible: true
                Layout.preferredWidth: 187
                Layout.alignment: Qt.AlignCenter
                text: qsTr("FINISH")
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }
}


