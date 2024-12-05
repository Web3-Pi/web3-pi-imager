import QtQuick 2.15

QtObject {
    id: versionManager

    property var osModel: ListModel {}
    property var osListModel: ListModel {}

    function onFileSelected(file) {
        imageWriter.setSrc(file)
        settings.selectedOS = imageWriter.srcFileName()
        osListModel.set(osListModel.count - 1, { text: settings.selectedOS });
    }

    function onOsListPrepared() {
        fetchOSList()
    }

    function fetchOSList() {
        const osListString = imageWriter.getFilteredOSlist();
        const osListJson = JSON.parse(osListString)
        const osListParsed = oslistFromJson(osListJson)
        if (osListParsed === false) {
            // TODO: show error
            return
        }
        osModel.clear()
        osListModel.clear()
        for (const i in osListParsed) {
            osModel.append(osListParsed[i])
            osListModel.append({ text: String(osListParsed[i].name) });
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
}