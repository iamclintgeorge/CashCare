import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.example 1.0

Rectangle {
    id: logPage
    visible: false
    color: "#FFFFFF"

    NetworkSniffer {
        id: networkSniffer
        onPacketInfoChanged: {
            if (riskNote !== "No risks detected") {
                var lines = packetInfo.split("\n");
                var logEntry = {
                    packetNumber: networkSniffer.totalPackets,
                    source: "",
                    destination: "",
                    protocol: "",
                    riskNote: networkSniffer.riskNote,
                    timestamp: Qt.formatDateTime(new Date(), "yyyy-MM-dd HH:mm:ss")
                };

                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].includes("Source IP:")) logEntry.source = lines[i].split(":")[1].trim();
                    else if (lines[i].includes("Destination IP:")) logEntry.destination = lines[i].split(":")[1].trim();
                    else if (lines[i].includes("Protocol:")) logEntry.protocol = lines[i].split(":")[1].trim();
                }

                logModel.append(logEntry);
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        Text {
            text: "Risky/Fraudulent Packet Log"
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
                model: ListModel { id: logModel }
                delegate: Rectangle {
                    width: parent.width
                    height: 60
                    color: index % 2 === 0 ? "#f9f9f9" : "white"
                    radius: 5

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            text: "#" + model.packetNumber + " | " + model.timestamp
                            font.pixelSize: 14
                            font.bold: true
                            color: "#2c3e50"
                        }

                        Text {
                            text: model.source + " → " + model.destination + " (" + model.protocol + ") - " + model.riskNote
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
            background: Rectangle {
                color: "#7f8c8d"
                radius: 8
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
            }
            onClicked: pageStack.clear()
        }
    }
}
