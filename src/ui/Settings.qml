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

    property string mode: "single";
    property string hostname: "eop-1";
    property string hostnameExecution: "eop-1-exec";
    property string hostnameConsesnus: "eop-1-cons";
    property string defaultNetwork: "mainnet";
    property string executionClient: "geth";
    property string consensusClient: "nimbus";
    property string executionPort: "30303"
    property string consensusPort: "9000";
    property string executionEndpointAddress: "http://localhost:8551";
    property bool executionEndpointAddressChecked: true;
    property bool monitoring: true;
    property bool formatStorage: false;

    property var localeOptions: {
        "checked": true,
        "timezone":  imageWriter.getTimezone() || "US/Central",
        "keyboardLayout":  imageWriter.getCurrentKeyboard() || "us",
    };
    property var wifiOptions: {
        "checked": false,
        "ssid":  imageWriter.getSSID() || "",
        "password":  "",
        "ssidHidden": false,
        "wifiCountry": "us"
    }

    function initialize() {
        loadSavedSettings()
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

        hostname = mode === "execution" ? hostnameExecution : mode === "consensus" ? hostnameConsesnus : hostname

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

        if (executionClient === "geth" && mode !== "consensus") {
            addConfig("geth=true")
        } else {
            addConfig("geth=false")
        }

        if (consensusClient === "nimbus" && mode !== "execution") {
            addConfig("nimbus=true")
            addConfig("lighthouse=false")
        } else if (consensusClient === "lighthouse" && mode !== "execution") {
            addConfig("nimbus=false")
            addConfig("lighthouse=true")
        } else {
            addConfig("nimbus=false")
            addConfig("lighthouse=false")
        }

        if (executionEndpointAddress.checked) {
            addConfig(`exec_url=${executionEndpointAddress}`)
        } else {
            if (mode === "consensus") {
                addConfig(`exec_url=http://${hostnameExecution}.local:8551`)
            }
        }

        if (executionPort && executionClient === 'geth' && mode !== "consensus") {
            addConfig("geth_port=" + executionPort)
        }
        if (consensusPort && mode !== "execution") {
            if (consensusClient === 'nimbus') {
                addConfig("nimbus_port="+consensusPort)
            } else if (consensusClient === 'lighthouse') {
                addConfig("lighthouse_port=" + consensusPort)
            }
        }

        if (defaultNetwork) {
            addConfig("eth_network="+defaultNetwork)
        }

        if (monitoring && mode !== "execution") {
            addConfig("influxdb=true")
            addConfig( "grafana=true")
            addConfig( "bnm=true")
        } else {
            addConfig("influxdb=false")
            addConfig( "grafana=false")
            addConfig( "bnm=false")
        }

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

        imageWriter.setImageCustomization(config, cmdline, firstrun, cloudinit, cloudinitnetwork, formatStorage, mode !== "single")
    }

    function save() {
        const settings = {
            hostname,
            hostnameExecution,
            hostnameConsesnus,
            defaultNetwork,
            executionClient,
            consensusClient,
            executionPort,
            consensusPort,
            executionEndpointAddressChecked,
            localeOptions,
            wifiOptions,
            monitoring,
            formatStorage,
        };

        if (executionEndpointAddressChecked) {
            settings.executionEndpointAddress = executionEndpointAddress
        }
        if (localeOptions.checked) {
            settings.localeOptions = localeOptions
        }
        if (wifiOptions.checked) {
            settings.wifiOptions = wifiOptions
        }

        imageWriter.setSavedCustomizationSettings(settings)
    }

    function loadDefaults() {
        hostname = "eop-1"
        hostnameExecution = "eop-1-exec"
        hostnameConsesnus = "eop-1-cons"
        defaultNetwork = "mainnet"
        executionClient = "geth"
        consensusClient = "nimbus"
        executionPort = "30303"
        consensusPort = "9000"
        monitoring = true
        formatStorage = false
    }

    function loadDefaultsAdvanced() {
        executionEndpointAddress = "http://localhost:8551"
        executionEndpointAddressChecked = true
        localeOptions = {
            "checked": true,
            "timezone":  imageWriter.getTimezone() || "US/Central",
            "keyboardLayout":  imageWriter.getCurrentKeyboard() || "us",
        };
        wifiOptions = {
            "checked": false,
            "ssid":  imageWriter.getSSID() || "",
            "password":  "",
            "ssidHidden": false,
            "wifiCountry": "us"
        }
    }

    function loadSavedSettings() {
        if (!imageWriter.hasSavedCustomizationSettings()) {
            return
        }
        const settings = imageWriter.getSavedCustomizationSettings()
        if (settings) {
            hostname = settings.hostname
            hostnameExecution = settings.hostnameExecution
            hostnameConsesnus = settings.hostnameConsesnus
            defaultNetwork = settings.defaultNetwork
            executionClient = settings.executionClient
            consensusClient = settings.consensusClient
            executionPort = settings.executionPort
            consensusPort = settings.consensusPort
            if (settings.executionEndpointAddress) executionEndpointAddress = settings.executionEndpointAddress
            if (settings.executionEndpointAddressChecked) executionEndpointAddressChecked = settings.executionEndpointAddressChecked
            if (settings.localeOptions) localeOptions = settings.localeOptions
            if (settings.wifiOptions) wifiOptions = settings.wifiOptions
            monitoring = settings.monitoring
            formatStorage = settings.formatStorage
        }
    }

    function selectOs(osItem) {
        if (osItem.url) {
            imageWriter.setSrc(osItem.url, osItem.image_download_size, osItem.extract_size, typeof(osItem.extract_sha256) != "undefined" ? osItem.extract_sha256 : "", typeof(osItem.contains_multiple_files) != "undefined" ? osItem.contains_multiple_files : false, "", osItem.name, typeof(osItem.init_format) != "undefined" ? osItem.init_format : "")
            settings.selectedOS = osItem.name
        }
    }
}
