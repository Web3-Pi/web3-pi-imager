import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Material.impl

Popup {
    id: storagePopup
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

    Material.theme: Material.Light

    property string mode: "execution"

    signal selected(string mode)

    // background of title
    Rectangle {
        id: dstpopup_title_background
        color: Material.background
        anchors.left: parent.left
        anchors.top: parent.top
        height: 35
        width: parent.width

        Text {
            text: getTitle()
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            font.family: outfit.name
            font.bold: true
            color: Material.foreground
            font.pixelSize: 16
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
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    storagePopup.close()
                }
            }
        }
    }
    // line under title
    Rectangle {
        id: dstpopup_title_separator
        color: Material.primary
        width: parent.width
        anchors.top: dstpopup_title_background.bottom
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
                            font.family: outfit.name
                            font.pixelSize: 14
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
                            font.family: outfit.name
                            font.pixelSize: 14
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

    MsgPopup {
        id: confirmwritepopup
        continueButton: false
        yesButton: true
        noButton: true
        title: qsTr("Warning")
        modal: true
        onYes: {
            if (!imageWriter.readyToWrite()) {
                // TODO: show error ... ?
                console.log("Image writer is not ready to write")
                return
            }
            selected(mode)
        }

        function askForConfirmation() {
            text = qsTr("All existing data on '%1' will be erased.<br>Are you sure you want to continue?").arg(settings.selectedDsc)
            openPopup()
        }
    }

    function selectDstItem(d) {
        if (d.isReadOnly) {
            onError(qsTr("SD card is write protected.<br>Push the lock switch on the left side of the card upwards, and try again."))
            return
        }
        storagePopup.close()
        imageWriter.setDst(d.device, d.size)
        settings.selectedDsc = d.description
        confirmwritepopup.askForConfirmation()
    }

    function getTitle() {
        if (mode === "single") {
            return qsTr("Storage for Single Mode Device")
        } else if (mode === "execution") {
            return qsTr("Storage for Execution Device")
        } else if (mode === "consensus") {
            return qsTr("Storage for Consensus Device")
        }
        return qsTr("Storage")
    }

    Timer {
        /* Verify if default drive is in our list after 100 ms */
        id: setDefaultDest
        property string drive : ""
        interval: 100
        onTriggered: {
            for (var i = 0; i < driveListModel.rowCount(); i++)
            {
                /* FIXME: there should be a better way to iterate drivelist than
                   fetch data by numeric role number */
                if (driveListModel.data(driveListModel.index(i,0), 0x101) === drive) {
                    selectDstItem({
                        device: drive,
                        description: driveListModel.data(driveListModel.index(i,0), 0x102),
                        size: driveListModel.data(driveListModel.index(i,0), 0x103),
                        readonly: false
                    })
                    break
                }
            }
        }
    }

}
