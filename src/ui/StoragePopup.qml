import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

Popup {
    id: dstpopup
    x: 50
    y: 25
    width: parent.width-100
    height: parent.height-50
    padding: 0
    closePolicy: Popup.CloseOnEscape
    onClosed: imageWriter.stopDriveListPolling()
    onOpened: {
        imageWriter.startDriveListPolling()
        dstlist.forceActiveFocus()
    }

    property string clientType: "execution"

    signal selected()

    // background of title
    Rectangle {
        id: dstpopup_title_background
        color: "#f5f5f5"
        anchors.left: parent.left
        anchors.top: parent.top
        height: 35
        width: parent.width

        Text {
            text: qsTr("Storage")
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
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    dstpopup.close()
                }
            }
        }
    }
    // line under title
    Rectangle {
        id: dstpopup_title_separator
        color: "#afafaf"
        width: parent.width
        anchors.top: dstpopup_title_background.bottom
        height: 1
    }
    ListView {
        id: dstlist
        model: driveListModel
        delegate: dstdelegate

        anchors.top: dstpopup_title_separator.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        boundsBehavior: Flickable.StopAtBounds
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        clip: true

        Label {
            anchors.fill: parent
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            visible: parent.count == 0
            text: qsTr("No storage devices found")
            font.bold: true
        }

        ScrollBar.vertical: ScrollBar {
            width: 10
            policy: dstlist.contentHeight > dstlist.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
        }

        Keys.onSpacePressed: {
            if (currentIndex == -1)
                return
            selectDstItem(currentItem)
        }
        Accessible.onPressAction: {
            if (currentIndex == -1)
                return
            selectDstItem(currentItem)
        }
        Keys.onEnterPressed: Keys.onSpacePressed(event)
        Keys.onReturnPressed: Keys.onSpacePressed(event)
    }

    Component {
        id: dstdelegate

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.topMargin: 1
            height: 61
            Accessible.name: {
                var txt = description+" - "+(size/1000000000).toFixed(1)+" gigabytes"
                if (mountpoints.length > 0) {
                    txt += qsTr("Mounted as %1").arg(mountpoints.join(", "))
                }
                return txt;
            }
            property string description: model.description
            property string device: model.device
            property string size: model.size

            Rectangle {
                id: dstbgrect
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 60

                color: mouseOver ? "#f5f5f5" : "#ffffff"
                property bool mouseOver: false

                RowLayout {
                    anchors.fill: parent

                    Item {
                        width: 25
                    }

                    Image {
                        id: dstitem_image
                        source: isUsb ? "icons/ic_usb_40px.svg" : isScsi ? "icons/ic_storage_40px.svg" : "icons/ic_sd_storage_40px.svg"
                        verticalAlignment: Image.AlignVCenter
                        fillMode: Image.Pad
                        width: 64
                        height: 60
                    }

                    Item {
                        width: 25
                    }

                    ColumnLayout {
                        Text {
                            textFormat: Text.StyledText
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true
                            font.family: roboto.name
                            font.pointSize: 12
                            color: isReadOnly ? "grey" : "";
                            text: {
                                var sizeStr = (size/1000000000).toFixed(1)+ " " + qsTr("GB");
                                return description + " - " + sizeStr;
                            }

                        }
                        Text {
                            textFormat: Text.StyledText
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true
                            font.family: roboto.name
                            font.pointSize: 12
                            color: "grey"
                            text: {
                                var txt= qsTr("Mounted as %1").arg(mountpoints.join(", "));
                                if (isReadOnly) {
                                    txt += " " + qsTr("[WRITE PROTECTED]")
                                }
                                return txt;
                            }
                        }
                    }
                }

            }
            Rectangle {
                id: dstborderrect
                anchors.top: dstbgrect.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "#dcdcdc"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onEntered: {
                    dstbgrect.mouseOver = true
                }

                onExited: {
                    dstbgrect.mouseOver = false
                }

                onClicked: {
                    selectDstItem(model)
                }
            }
        }
    }

    function selectDstItem(d) {
        if (d.isReadOnly) {
            onError(qsTr("SD card is write protected.<br>Push the lock switch on the left side of the card upwards, and try again."))
            return
        }
        dstpopup.close()
        imageWriter.setDst(d.device, d.size)
        window.selecteddstdesc = d.description
        selected()

    }
}
