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

    signal saveSettingsSignal(var settings)

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

    property string hostname
    property string defaultNetwork
    property string selecteddstdesc
    property string selectedos
    property string executionClient
    property string consensusClient
    property string executionPort
    property string consensusPort
    property string executionEndpointAddress
    property string keyboardLayout
    property var localeOptions: {
        "checked": false,
        "timezone": "",
        "keyboardLayout": "",
    }
    property var wifiOptions: {
        "checked": false,
        "ssid": "",
        "password": "",
        "ssidHidden": false,
        "wifiCountry": "",
    }



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
                initialItem: ModeSelector {
                    id: modeSelector
                }
            }
        }
    }

    SingleModeForm {
        id: singleModeForm
        visible: false
    }

    DualModeForm {
        id: dualModeForm
        visible: false
    }

    WritingPage {
        id: writingPage
        objectName: "writingPage"
        visible: false
        onEnd: {
            stackView.pop()
        }
    }

    StoragePopup {
        id: dstpopup
        onSelected: {
            if (!imageWriter.readyToWrite()) {
                // TODO: show error ... ?
                return
            }
            confirmwritepopup.askForConfirmation()
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
        onYes: startWrite()

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
        // TODO
        // chkTelemtry.checked = imageWriter.getBoolSetting("telemetry")
        const savedSettings = imageWriter.getSavedCustomizationSettings()

        singleModeForm.initialize(savedSettings)
        // dualModeForm.initialize(savedSettings)
        advancedSettings.initialize(savedSettings)

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

    function applySettings() {
        cmdline = ""
        config = ""
        firstrun = ""
        cloudinit = ""
        cloudinitrun = ""
        cloudinitwrite = ""
        cloudinitnetwork = ""

        if (hostname) {
            addFirstRun("CURRENT_HOSTNAME=`cat /etc/hostname | tr -d \" \\t\\n\\r\"`")
            addFirstRun("if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then")
            addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname "+hostname)
            addFirstRun("else")
            addFirstRun("   echo "+hostname+" >/etc/hostname")
            addFirstRun("   sed -i \"s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\\t"+hostname+"/g\" /etc/hosts")
            addFirstRun("fi")

            addCloudInit("hostname: "+hostname)
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

        if (executionEndpointAddress.length) {
            addConfig(executionEndpointAddress)
        }

        if (executionPort && executionClient === 'geth') {
            addConfig("geth_port=" + executionPort)
        }
        if (consensusPort) {
            if (consensusClient === 'nimbus') {
                addConfig("nimbus_port="+consensusPort)
            } else if (consensusClient === 'lighthouse') {
                addConfig("lighthouse_port=" + consensusPort)
            }
        }

        // if (chkMonitoring.checked) {
        //     addConfig("influxdb=true")
        //     addConfig( "grafana=true")
        // }

        if (localeOptions.checked) {

            var kbdconfig = "XKBMODEL=\"pc105\"\n"
            kbdconfig += "XKBLAYOUT=\""+localeOptions.keyboardLayout+"\"\n"
            kbdconfig += "XKBVARIANT=\"\"\n"
            kbdconfig += "XKBOPTIONS=\"\"\n"

            addFirstRun("if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then")
            addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_keymap "+escapeshellarg(localeOptions.keyboardLayout))
            addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_timezone "+escapeshellarg(localeOptions.timezone))
            addFirstRun("else")
            addFirstRun("   rm -f /etc/localtime")
            addFirstRun("   echo \""+localeOptions.timezone+"\" >/etc/timezone")
            addFirstRun("   dpkg-reconfigure -f noninteractive tzdata")
            addFirstRun("cat >/etc/default/keyboard <<'KBEOF'")
            addFirstRun(kbdconfig)
            addFirstRun("KBEOF")
            addFirstRun("   dpkg-reconfigure -f noninteractive keyboard-configuration")
            addFirstRun("fi")

            addCloudInit("timezone: "+localeOptions.timezone)
            addCloudInit("keyboard:")
            addCloudInit("  model: pc105")
            addCloudInit("  layout: \"" + localeOptions.keyboardLayout + "\"")
        }

        if (wifiOptions.checked) {
            var wpaconfig = "country="+wifiOptions.wifiCountry+"\n"
            wpaconfig += "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\n"
            wpaconfig += "ap_scan=1\n\n"
            wpaconfig += "update_config=1\n"
            wpaconfig += "network={\n"
            if (wifiOptions.ssidHidden) {
                wpaconfig += "\tscan_ssid=1\n"
            }
            wpaconfig += "\tssid=\""+wifiOptions.ssid+"\"\n"

            const isPassphrase = wifiOptions.password.length >= 8 &&
                wifiOptions.password.length < 64
            var cryptedPsk = isPassphrase ? imageWriter.pbkdf2(wifiOptions.password, wifiOptions.ssid)
                : wifiOptions.password
            wpaconfig += "\tpsk="+cryptedPsk+"\n"
            wpaconfig += "}\n"

            addFirstRun("if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then")
            addFirstRun("   /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan "
                +(wifiOptions.ssidHidden ? " -h " : "")
                +escapeshellarg(wifiOptions.ssid)+" "+escapeshellarg(cryptedPsk)+" "+escapeshellarg(wifiOptions.wifiCountry))
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
            cloudinitnetwork += "      \""+wifiOptions.ssid+"\":\n"
            cloudinitnetwork += "        password: \""+cryptedPsk+"\"\n"
            if (wifiOptions.ssidHidden) {
                cloudinitnetwork += "        hidden: true\n"
            }

            addCmdline("cfg80211.ieee80211_regdom="+wifiOptions.wifiCountry)
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

    function saveSettings() {
        // TODO
        // var settings = { };
        // if (fieldHostname.length) {
        //     settings.hostname = fieldHostname.text
        // }
        // settings.timezone = fieldTimezone.editText
        // settings.keyboardLayout = fieldKeyboardLayout.editText
        //
        // imageWriter.setSetting("telemetry", chkTelemtry.checked)
        // hasSavedSettings = true
        // saveSettingsSignal(settings)
    }


    function onFileSelected(file) {
        imageWriter.setSrc(file)
        osbutton.text = imageWriter.srcFileName()
        ospopup.close()
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

    function startWrite() {
        stackView.push(writingPage)
        imageWriter.setVerifyEnabled(true)
        imageWriter.startWrite()
    }
}
