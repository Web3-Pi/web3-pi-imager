import QtQuick 2.15

QtObject {
    property string config;
    property string cmdline;
    property string firstrun;
    property string cloudinit;
    property string cloudinitrun;
    property string cloudinitwrite;
    property string cloudinitnetwork;

    property string selectedOS;
    property string selectedDsc;

    property string hostname;
    property string hostnameExecution;
    property string hostnameConsesnus;
    property string defaultNetwork;
    property string executionClient;
    property string consensusClient;
    property string executionPort;
    property string consensusPort;
    property string executionEndpointAddress;
    property string keyboardLayout;

    property var localeOptions: {
        "checked": false,
        "timezone": "",
        "keyboardLayout": "",
    };
    property var wifiOptions: {
        "checked": false,
        "ssid": "",
        "password": "",
        "ssidHidden": false,
        "wifiCountry": ""
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

    function apply() {
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

        if (executionClient === "geth") {
            addConfig("geth=true")
        } else {
            addConfig("geth=false")
        }

        if (consensusClient === "nimbus") {
            addConfig("nimbus=true")
            addConfig("lighthouse=false")
        } else if (consensusClient === "lighthouse") {
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

    function save() {
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

    function selectOs(d) {
        imageWriter.setSrc(d.url, d.image_download_size, d.extract_size, typeof(d.extract_sha256) != "undefined" ? d.extract_sha256 : "", typeof(d.contains_multiple_files) != "undefined" ? d.contains_multiple_files : false, "", d.name, typeof(d.init_format) != "undefined" ? d.init_format : "")
        selectedOS = d.name
    }
}
