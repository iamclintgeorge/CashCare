import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: logPage
    visible: false
    color: "#FFFFFF"

    ListModel {
        id: logModel
    }

    function addLogEntry(action) {
        var timestamp = Qt.formatDateTime(new Date(), "yyyy-MM-dd HH:mm:ss");
        logModel.append({ "timestamp": timestamp, "action": action });
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        Text {
            text: "User Activity Log"
            font.family: "Arial"
            font.bold: true
            font.pointSize: 24
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: logList
                model: logModel
                delegate: Rectangle {
                    width: parent.width
                    height: 60
                    color: index % 2 === 0 ? "#f9f9f9" : "white"
                    radius: 5

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        Text {
                            text: model.timestamp
                            font.pixelSize: 14
                            font.bold: true
                            color: "#2c3e50"
                        }
                        Text {
                            text: model.action
                            font.pixelSize: 12
                            color: "#7f8c8d"
                        }
                    }
                }
            }
        }

        Button {
            text: "⬅ Back to Main"
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle { color: "#7f8c8d"; radius: 8 }
            contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter }
            onClicked: pageStack.clear()
        }
    }
}
