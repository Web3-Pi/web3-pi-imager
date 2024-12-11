import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2

ImComboBox {
    id: fieldImageVersion
    background: Rectangle {
        color: "white"
        radius: 9
    }
    selectTextByMouse: true
    Layout.fillWidth: true
    Layout.minimumHeight: 42
    model: versionManager.osListModel
    currentIndex: 0
    Component.onCompleted: {
        if (model) {
            model.onCountChanged.connect(() => {
                currentIndex = 0;
            });
        }

    }

    onActivated: {
        checkLocalFile()
    }


    function getSelectedOs() {
        return versionManager.osModel.get(fieldImageVersion.currentIndex);
    }

    function checkLocalFile() {
        if (getSelectedOs().url === "") {
            imageWriter.openFileDialog()
        }
    }

}



