/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2020 Raspberry Pi Ltd
 */

import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
import "components"

ApplicationWindow {
    id: window
    visible: true

    width: imageWriter.isEmbeddedMode() ? -1 : 480
    height: imageWriter.isEmbeddedMode() ? -1 : 730
    minimumWidth: imageWriter.isEmbeddedMode() ? -1 : 480
    minimumHeight: imageWriter.isEmbeddedMode() ? -1 : 730

    title: qsTr("Web3 Pi Imager v%1").arg(imageWriter.constantVersion())

    property bool dualMode: false;
    property bool initialized: false
    property bool hasSavedSettings: false
    property string config
    property string cmdline
    property string firstrun
    property string cloudinit
    property string cloudinitrun
    property string cloudinitwrite
    property string cloudinitnetwork

    property string selecteddstdesc
    property string selectedos
    property string executionclient
    property string consensusclient

    signal saveSettingsSignal(var settings)

    FontLoader {id: roboto;      source: "fonts/Roboto-Regular.ttf"}
    FontLoader {id: robotoLight; source: "fonts/Roboto-Light.ttf"}
    FontLoader {id: robotoBold;  source: "fonts/Roboto-Bold.ttf"}


    Component.onCompleted: {
        if (!initialized) {
            initialize()
            if (imageWriter.hasSavedCustomizationSettings()) {
                applySettings()
            }
        }
    }

    Shortcut {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: {
            if (!progressBar.visible) {
                Qt.quit()
            }
        }
    }

    ColumnLayout {
        id: bg
        spacing: 0
        anchors.fill: parent

        Rectangle {
            id: logoContainer
            implicitHeight: window.height/5

            Image {
                id: image
                source: "icons/logo_web3_pi_imager.png"

                // Specify the maximum size of the image
                width: window.width
                height: window.height / 5

                // Within the image's specified size rectangle, resize the
                // image to fit within the rectangle while keeping its aspect
                // ratio the same.  Preserving the aspect ratio implies some
                // extra padding between the Image's extend and the actual
                // image content: align left so all this padding is on the
                // right.
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignLeft

                // Keep the left side of the image 40 pixels from the left
                // edge
                anchors.left: logoContainer.left
                anchors.leftMargin: 20

                // Equal padding above and below the image
                anchors.top: logoContainer.top
                anchors.bottom: logoContainer.bottom
                anchors.topMargin: window.height / 40
                anchors.bottomMargin: window.height / 40
            }
        }

        Rectangle {
            color: "#e51763"
            implicitWidth: window.width
            implicitHeight: window.height * (1 - 1/5)

            StackView {
                id: stackView
                anchors.fill: parent
                // initialItem: "ModeSelector.qml"
                // initialItem: "SingleModeForm.qml"
                initialItem: ModeSelector {}
                // initialItem: "Writing.qml"

                // Component.onCompleted: {
                //     push("ModeSelector.qml")
                // }

                Component {
                    id: singleModeForm
                    SingleModeForm {}
                }

                Component {
                    id: dualModeForm
                    DualModeForm {}
                }
            }
        }
    }


    /*
      Popup for storage device selection
     */
    Popup {
        id: dstpopup
        x: 50
        y: 25
        width: parent.width-100
        height: parent.height-50
        padding: 0
        closePolicy: Popup.CloseOnEscape
        onClosed: imageWriter.stopDriveListPolling()

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

    MsgPopup {
        id: msgpopup
        onOpened: {
            forceActiveFocus()
        }
    }

    MsgPopup {
        id: quitpopup
        continueButton: false
        yesButton: true
        noButton: true
        title: qsTr("Are you sure you want to quit?")
        text: qsTr("Raspberry Pi Imager is still busy.<br>Are you sure you want to quit?")
        onYes: {
            Qt.quit()
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
            mainForm.visible = false;
            writingProcess.visible = true
            langbarRect.visible = false
            progressText.text = qsTr("Preparing to write...");
            progressBar.indeterminate = true
            progressBar.Material.accent = "#ffffff"
            imageWriter.setVerifyEnabled(true)
            imageWriter.startWrite()
        }

        function askForConfirmation()
        {
            text = qsTr("All existing data on '%1' will be erased.<br>Are you sure you want to continue?").arg(window.selecteddstdesc)
            openPopup()
        }

        onOpened: {
            forceActiveFocus()
        }
    }

    MsgPopup {
        id: updatepopup
        continueButton: false
        yesButton: true
        noButton: true
        property url url
        title: qsTr("Update available")
        text: qsTr("There is a newer version of Imager available.<br>Would you like to visit the website to download it?")
        onYes: {
            Qt.openUrlExternally(url)
        }
    }

    AdvancedSettings {
        id: advancedSettings
    }

    function initialize() {
        chkTelemtry.checked = imageWriter.getBoolSetting("telemetry")
        var settings = imageWriter.getSavedCustomizationSettings()
        fieldTimezone.model = imageWriter.getTimezoneList()
        fieldKeyboardLayout.model = imageWriter.getKeymapLayoutList()

        window.executionclient = fieldExecutionClient.model.get(fieldExecutionClient.currentIndex).value
        window.consensusclient = fieldConsensusClient.model.get(fieldConsensusClient.currentIndex).value

        if (Object.keys(settings).length) {
            hasSavedSettings = true
        }
        if ('hostname' in settings) {
            fieldHostname.text = settings.hostname
        }

        if ('wifiSSID' in settings) {
            optionspopup.wifiOptions.ssid = settings.wifiSSID
            if ('wifiSSIDHidden' in settings && settings.wifiSSIDHidden) {
                optionspopup.wifiOptions.ssidHidden.checked = true
            }
            optionspopup.wifiOptions.psassword = settings.wifiPassword
            optionspopup.wifiOptions.wifiCountry = settings.wifiCountry
            optionspopup.wifiOptions.checked = true
        } else {
            optionspopup.wifiOptions.wifiCountry = "GB"
            optionspopup.wifiOptions.ssid = imageWriter.getSSID()
            if (optionspopup.wifiOptions.ssid.length) {
                optionspopup.wifiOptions.psassword = imageWriter.getPSK()
            }
        }
        var tz;
        if ('timezone' in settings) {
            tz = settings.timezone
        } else {
            tz = imageWriter.getTimezone()
        }
        var tzidx = fieldTimezone.find(tz)
        if (tzidx === -1) {
            fieldTimezone.editText = tz
        } else {
            fieldTimezone.currentIndex = tzidx
        }
        if ('keyboardLayout' in settings) {
            fieldKeyboardLayout.currentIndex = fieldKeyboardLayout.find(settings.keyboardLayout)
            if (fieldKeyboardLayout.currentIndex == -1) {
                fieldKeyboardLayout.editText = settings.keyboardLayout
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
        initialized = true
    }

    function addCmdline(s) {
        cmdline += " "+s
    }
    function addConfig(s) {
        config += s+"\n"
    }
    function addFirstRun(s) {
        firstrun += s+"\n"
    }
    function escapeshellarg(arg) {
        return "'"+arg.replace(/'/g, "'\"'\"'")+"'"
    }
    function addCloudInit(s) {
        cloudinit += s+"\n"
    }
    function addCloudInitWriteFile(name, content, perms) {
        cloudinitwrite += "- encoding: b64\n"
        cloudinitwrite += "  content: "+Qt.btoa(content)+"\n"
        cloudinitwrite += "  owner: root:root\n"
        cloudinitwrite += "  path: "+name+"\n"
        cloudinitwrite += "  permissions: '"+perms+"'\n"
    }
    function addCloudInitRun(cmd) {
        cloudinitrun += "- "+cmd+"\n"
    }

    function applySettings()
    {
        cmdline = ""
        config = ""
        firstrun = ""
        cloudinit = ""
        cloudinitrun = ""
        cloudinitwrite = ""
        cloudinitnetwork = ""

        if (fieldHostname.length) {
            addFirstRun("CURRENT_HOSTNAME=`cat /etc/hostname | tr -d \" \\t\\n\\r\"`")
            addFirstRun("if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then")
            addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname "+fieldHostname.text)
            addFirstRun("else")
            addFirstRun("   echo "+fieldHostname.text+" >/etc/hostname")
            addFirstRun("   sed -i \"s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\\t"+fieldHostname.text+"/g\" /etc/hosts")
            addFirstRun("fi")

            addCloudInit("hostname: "+fieldHostname.text)
            addCloudInit("manage_etc_hosts: true")
            addCloudInit("packages:")
            addCloudInit("- avahi-daemon")
            /* Disable date/time checks in apt as NTP may not have synchronized yet when installing packages */
            addCloudInit("apt:")
            addCloudInit("  conf: |")
            addCloudInit("    Acquire {")
            addCloudInit("      Check-Date \"false\";")
            addCloudInit("    };")
            addCloudInit("")
        }

        if (window.executionclient === "geth") {
            addConfig("geth=true")
        } else {
            addConfig("geth=false")
        }

        if (window.consensusclient === "nimbus") {
            addConfig("nimbus=true")
            addConfig("lighthouse=false")
        } else if (window.consensusclient === "lighthouse") {
            addConfig("nimbus=false")
            addConfig("lighthouse=true")
        }

        if (optionspopup.executionEndpointAddress.checked) {
            addConfig(optionspopup.executionEndpointAddress.value)
        }

        if (fieldExecutionPort.length && window.executionclient === 'geth') {
            addConfig("geth_port="+fieldExecutionPort.text)
        }
        if (fieldConsensusPort.length) {
            if (window.consensusclient === 'nimbus') {
                addConfig("nimbus_port="+fieldConsensusPort.text)
            } else if (window.consensusclient === 'lighthouse') {
                addConfig("lighthouse_port=" + fieldConsensusPort.text)
            }
        }

        if (chkMonitoring.checked) {
            addConfig("influxdb=true")
            addConfig( "grafana=true")
        }

        var kbdconfig = "XKBMODEL=\"pc105\"\n"
        kbdconfig += "XKBLAYOUT=\""+fieldKeyboardLayout.editText+"\"\n"
        kbdconfig += "XKBVARIANT=\"\"\n"
        kbdconfig += "XKBOPTIONS=\"\"\n"

        addFirstRun("if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then")
        addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_keymap "+escapeshellarg(fieldKeyboardLayout.editText))
        addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_timezone "+escapeshellarg(fieldTimezone.editText))
        addFirstRun("else")
        addFirstRun("   rm -f /etc/localtime")
        addFirstRun("   echo \""+fieldTimezone.editText+"\" >/etc/timezone")
        addFirstRun("   dpkg-reconfigure -f noninteractive tzdata")
        addFirstRun("cat >/etc/default/keyboard <<'KBEOF'")
        addFirstRun(kbdconfig)
        addFirstRun("KBEOF")
        addFirstRun("   dpkg-reconfigure -f noninteractive keyboard-configuration")
        addFirstRun("fi")

        addCloudInit("timezone: "+fieldTimezone.editText)
        addCloudInit("keyboard:")
        addCloudInit("  model: pc105")
        addCloudInit("  layout: \"" + fieldKeyboardLayout.editText + "\"")

        if (optionspopup.wifiOptions.checked) {
            var wpaconfig = "country="+optionspopup.wifiOptions.wifiCountry+"\n"
            wpaconfig += "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\n"
            wpaconfig += "ap_scan=1\n\n"
            wpaconfig += "update_config=1\n"
            wpaconfig += "network={\n"
            if (optionspopup.wifiOptions.ssidHidden) {
                wpaconfig += "\tscan_ssid=1\n"
            }
            wpaconfig += "\tssid=\""+optionspopup.wifiOptions.ssid+"\"\n"

            const isPassphrase = optionspopup.wifiOptions.password.length >= 8 &&
                optionspopup.wifiOptions.password.length < 64
            var cryptedPsk = isPassphrase ? imageWriter.pbkdf2(optionspopup.wifiOptions.password, optionspopup.wifiOptions.ssid)
                : optionspopup.wifiOptions.password
            wpaconfig += "\tpsk="+cryptedPsk+"\n"
            wpaconfig += "}\n"

            addFirstRun("if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then")
            addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan "
                +(optionspopup.wifiOptions.ssidHidden ? " -h " : "")
                +escapeshellarg(optionspopup.wifiOptions.ssid)+" "+escapeshellarg(cryptedPsk)+" "+escapeshellarg(optionspopup.wifiOptions.wifiCountry))
            addFirstRun("else")
            addFirstRun("cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'")
            addFirstRun(wpaconfig)
            addFirstRun("WPAEOF")
            addFirstRun("   chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf")
            addFirstRun("   rfkill unblock wifi")
            addFirstRun("   for filename in /var/lib/systemd/rfkill/*:wlan ; do")
            addFirstRun("       echo 0 > $filename")
            addFirstRun("   done")
            addFirstRun("fi")


            cloudinitnetwork  = "version: 2\n"
            cloudinitnetwork += "wifis:\n"
            cloudinitnetwork += "  renderer: networkd\n"
            cloudinitnetwork += "  wlan0:\n"
            cloudinitnetwork += "    dhcp4: true\n"
            cloudinitnetwork += "    optional: true\n"
            cloudinitnetwork += "    access-points:\n"
            cloudinitnetwork += "      \""+optionspopup.wifiOptions.ssid+"\":\n"
            cloudinitnetwork += "        password: \""+cryptedPsk+"\"\n"
            if (optionspopup.wifiOptions.ssidHidden) {
                cloudinitnetwork += "        hidden: true\n"
            }

            addCmdline("cfg80211.ieee80211_regdom="+optionspopup.wifiOptions.wifiCountry)
        }

        if (firstrun.length) {
            firstrun = "#!/bin/bash\n\n"+"set +e\n\n"+firstrun
            addFirstRun("rm -f /boot/firstrun.sh")
            addFirstRun("sed -i 's| systemd.run.*||g' /boot/cmdline.txt")
            addFirstRun("exit 0")
            /* using systemd.run_success_action=none does not seem to have desired effect
               systemd then stays at "reached target kernel command line", so use reboot instead */
            //addCmdline("systemd.run=/boot/firstrun.sh systemd.run_success_action=reboot systemd.unit=kernel-command-line.target")
            // cmdline changing moved to DownloadThread::_customizeImage()
        }

        if (cloudinitwrite !== "") {
            addCloudInit("write_files:\n"+cloudinitwrite+"\n")
        }

        if (cloudinitrun !== "") {
            addCloudInit("runcmd:\n"+cloudinitrun+"\n")
        }

        imageWriter.setImageCustomization(config, cmdline, firstrun, cloudinit, cloudinitnetwork)
    }

    function saveSettings()
    {
        var settings = { };
        if (fieldHostname.length) {
            settings.hostname = fieldHostname.text
        }
        settings.timezone = fieldTimezone.editText
        settings.keyboardLayout = fieldKeyboardLayout.editText

        imageWriter.setSetting("telemetry", chkTelemtry.checked)
        hasSavedSettings = true
        saveSettingsSignal(settings)
    }

    /* Slots for signals imagewrite emits */
    function onDownloadProgress(now,total) {
        var newPos
        if (total) {
            newPos = now/(total+1)
        } else {
            newPos = 0
        }
        if (progressBar.value !== newPos) {
            if (progressText.text === qsTr("Cancelling..."))
                return

            progressText.text = qsTr("Writing... %1%").arg(Math.floor(newPos*100))
            progressBar.indeterminate = false
            progressBar.value = newPos
        }
    }

    function onVerifyProgress(now,total) {
        var newPos
        if (total) {
            newPos = now/total
        } else {
            newPos = 0
        }

        if (progressBar.value !== newPos) {
            if (cancelwritebutton.visible) {
                cancelwritebutton.visible = false
                cancelverifybutton.visible = true
            }

            if (progressText.text === qsTr("Finalizing..."))
                return

            progressText.text = qsTr("Verifying... %1%").arg(Math.floor(newPos*100))
            progressBar.Material.accent = "#6cc04a"
            progressBar.value = newPos
        }
    }

    function onPreparationStatusUpdate(msg) {
        progressText.text = qsTr("Preparing to write... (%1)").arg(msg)
    }

    function onOsListPrepared() {
        fetchOSlist()
    }

    function reset() {
        writingProcess.visible = false
        mainForm.visible = true;
    }

    function onError(msg) {
        msgpopup.title = qsTr("Error")
        msgpopup.text = msg
        msgpopup.openPopup()
        reset()
    }

    function onSuccess() {
        msgpopup.title = qsTr("Write Successful")
        if (window.selectedos === qsTr("Erase"))
            msgpopup.text = qsTr("<b>%1</b> has been erased<br><br>You can now remove the SD card from the reader").arg(window.selecteddstdesc)
        else if (imageWriter.isEmbeddedMode()) {
            //msgpopup.text = qsTr("<b>%1</b> has been written to <b>%2</b>").arg(osbutton.text).arg(dstbutton.text)
            /* Just reboot to the installed OS */
            Qt.quit()
        }
        else
            msgpopup.text = qsTr("<b>%1</b> has been written to <b>%2</b><br><br>You can now remove the SD card from the reader").arg(window.selectedos).arg(window.selecteddstdesc)
        if (imageWriter.isEmbeddedMode()) {
            msgpopup.continueButton = false
            msgpopup.quitButton = true
        }

        msgpopup.openPopup()
        imageWriter.setDst("")
        reset()
    }

    function onFileSelected(file) {
        imageWriter.setSrc(file)
        osbutton.text = imageWriter.srcFileName()
        ospopup.close()
    }

    function onCancelled() {
        reset()
    }

    function onFinalizing() {
        progressText.text = qsTr("Finalizing...")
    }

    function onNetworkInfo(msg) {
        networkInfo.text = msg
    }

    function shuffle(arr) {
        for (var i = 0; i < arr.length - 1; i++) {
            var j = i + Math.floor(Math.random() * (arr.length - i));

            var t = arr[j];
            arr[j] = arr[i];
            arr[i] = t;
        }
    }

    function checkForRandom(list) {
        for (var i in list) {
            var entry = list[i]

            if ("subitems" in entry) {
                checkForRandom(entry["subitems"])
                if ("random" in entry && entry["random"]) {
                    shuffle(entry["subitems"])
                }
            }
        }
    }

    function filterItems(list, tags, matchingType)
    {
        if (!tags || !tags.length)
            return

        var i = list.length
        while (i--) {
            var entry = list[i]

            if ("devices" in entry && entry["devices"].length) {
                var foundTag = false

                switch(matchingType) {
                case 0: /* exact matching */
                case 2: /* exact matching */
                    for (var j in tags)
                    {
                        if (entry["devices"].includes(tags[j]))
                        {
                            foundTag = true
                            break
                        }
                    }
                    /* If there's no match, remove this item from the list. */
                    if (!foundTag)
                    {
                        list.splice(i, 1)
                        continue
                    }
                    break
                case 1: /* Exlusive by prefix matching */
                case 3: /* Inclusive by prefix matching */
                    for (var deviceTypePrefix in tags) {
                        for (var deviceSpec in entry["devices"]) {
                            if (deviceSpec.startsWith(deviceTypePrefix)) {
                                foundTag = true
                                break
                            }
                        }
                        /* Terminate outer loop early if we've already
                             * decided it's a match
                             */
                        if (foundTag) {
                            break
                        }
                    }
                    /* If there's no match, remove this item from the list. */
                    if (!foundTag)
                    {
                        list.splice(i, 1)
                        continue
                    }
                    break
                }
            } else {
                /* No device list attached? If we're in an exclusive mode that's bad news indeed. */
                switch (matchingType) {
                case 0:
                case 1:
                    if (!("subitems" in entry)) {
                        /* If you're not carrying subitems, you're not going in. */
                        list.splice(i, 1)
                    }
                    break
                case 2:
                case 3:
                    /* Inclusive filtering. We're keeping this one. */
                    break;
                }
            }

            if ("subitems" in entry) {
                filterItems(entry["subitems"], tags, hwTagMatchingType)

                // If this sub-list has no items then hide it
                if (entry["subitems"].length == 0) {
                    list.splice(i, 1)
                }
            }
        }
    }

    function oslistFromJson(o) {
        var oslist_parsed = false
        var lang_country = Qt.locale().name
        if ("os_list_"+lang_country in o) {
            oslist_parsed = o["os_list_"+lang_country]
        }
        else if (lang_country.includes("_")) {
            var lang = lang_country.substr(0, lang_country.indexOf("_"))
            if ("os_list_"+lang in o) {
                oslist_parsed = o["os_list_"+lang]
            }
        }

        if (!oslist_parsed) {
            if (!"os_list" in o) {
                onError(qsTr("Error parsing os_list.json"))
                return false
            }

            oslist_parsed = o["os_list"]
        }

        checkForRandom(oslist_parsed)

        /* Flatten subitems to subitems_json */
        for (var i in oslist_parsed) {
            var entry = oslist_parsed[i];
            if ("subitems" in entry) {
                entry["subitems_json"] = JSON.stringify(entry["subitems"])
                delete entry["subitems"]
            }
        }

        return oslist_parsed
    }

    function selectNamedOS(name, collection)
    {
        for (var i = 0; i < collection.count; i++) {
            var os = collection.get(i)

            if (typeof(os.subitems_json) == "string" && os.subitems_json != "") {
                selectNamedOS(name, os.subitems_json)
            }
            else if (typeof(os.url) !== "undefined" && name === os.name) {
                selectOSitem(os, false)
                break
            }
        }
    }

    function fetchOSlist() {
        var oslist_json = imageWriter.getFilteredOSlist();
        var o = JSON.parse(oslist_json)
        var oslist_parsed = oslistFromJson(o)
        if (oslist_parsed === false)
            return
        osmodel.clear()
        for (var i in oslist_parsed) {
            osmodel.append(oslist_parsed[i])
            oslistmodel.append({ text: String(oslist_parsed[i].name) });
        }
        if (fieldImageVersion.count > 0) {
            fieldImageVersion.currentIndex = 0
        }
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

    function selectOSitem(d)
    {
        imageWriter.setSrc(d.url, d.image_download_size, d.extract_size, typeof(d.extract_sha256) != "undefined" ? d.extract_sha256 : "", typeof(d.contains_multiple_files) != "undefined" ? d.contains_multiple_files : false, "", d.name, typeof(d.init_format) != "undefined" ? d.init_format : "")
        window.selectedos = d.name
    }

    function selectDstItem(d) {
        if (d.isReadOnly) {
            onError(qsTr("SD card is write protected.<br>Push the lock switch on the left side of the card upwards, and try again."))
            return
        }

        dstpopup.close()
        imageWriter.setDst(d.device, d.size)
        window.selecteddstdesc = d.description
        // dstbutton.text = d.description
        // if (imageWriter.readyToWrite()) {
        //     writebutton.enabled = true
        // }

        // TODO: next step

        if (!imageWriter.readyToWrite()) {
            // TODO: show error ... ?
            return
        }
        confirmwritepopup.askForConfirmation()

    }
}
