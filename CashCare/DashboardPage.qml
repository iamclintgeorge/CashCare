import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.example 1.0

Rectangle {
    id: dashboardPage
    visible: false
    color: "#FFFFFF"

    NetworkSniffer {
        id: networkSniffer
        onPacketInfoChanged: {
            var lines = packetInfo.split("\n");
            var packet = {
                packetNumber: networkSniffer.totalPackets,
                sourceMac: "",
                destMac: "",
                source: "",
                destination: "",
                protocol: "",
                sourcePort: "",
                destinationPort: "",
                flags: "",
                windowSize: "",
                protocolDetected: "",
                payloadLength: "0",
                transactionAmount: networkSniffer.transactionAmount,
                paymentMethod: networkSniffer.paymentMethod,
                failedAttempts: networkSniffer.failedAttempts,
                riskNote: networkSniffer.riskNote,
                geolocation: ""
            };

            for (var i = 0; i < lines.length; i++) {
                if (lines[i].includes("Source MAC:")) packet.sourceMac = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Destination MAC:")) packet.destMac = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Source IP:")) packet.source = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Destination IP:")) packet.destination = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Protocol:")) packet.protocol = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Source Port:")) packet.sourcePort = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Destination Port:")) packet.destinationPort = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Flags:")) packet.flags = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Window Size:")) packet.windowSize = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Protocol Detected:")) packet.protocolDetected = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Payload Length:")) packet.payloadLength = lines[i].split(":")[1].trim();
                else if (lines[i].includes("Geolocation:")) packet.geolocation = lines[i].split(":")[1].trim();
            }

            if (packet.riskNote !== "No risks detected") {
                blockedPacketsModel.append(packet);
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        Text {
            text: "Network Security Dashboard"
            font.family: "Arial"
            font.bold: true
            font.pointSize: 24
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 10
                color: "#3498db"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: "📦 TOTAL PACKETS"
                        font.pixelSize: 14
                        color: "white"
                    }

                    Text {
                        text: networkSniffer.totalPackets
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 10
                color: "#e74c3c"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: "🚫 BLOCKED PACKETS"
                        font.pixelSize: 14
                        color: "white"
                    }

                    Text {
                        text: root.blockedPackets
                        font.pixelSize: 28
                        font.bold: true
                        color: "white" // Fixed from "arecolor"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 10
                color: "#2ecc71"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: "🌐 BANDWIDTH"
                        font.pixelSize: 14
                        color: "white"
                    }

                    Text {
                        text: networkSniffer.bandwidthUsage.toFixed(2) + " KB/s"
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }

        GroupBox {
            title: "🚨 Recent Blocked Activity"
            Layout.fillWidth: true
            Layout.fillHeight: true
            font.bold: true
            font.pixelSize: 16

            ListView {
                id: recentActivityList
                anchors.fill: parent
                model: ListModel { id: blockedPacketsModel }
                clip: true
                spacing: 5

                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    color: index % 2 === 0 ? "#f9f9f9" : "white"
                    radius: 5

                    RowLayout {
                        anchors.fill: parent
                        spacing: 15
                        anchors.margins: 10

                        Rectangle {
                            width: 5
                            height: parent.height
                            color: "#e74c3c"
                            radius: 2
                        }

                        ColumnLayout {
                            spacing: 3

                            Text {
                                text: model.source + " → " + model.destination
                                font.pixelSize: 14
                                font.bold: true
                                color: "#2c3e50"
                            }

                            Text {
                                text: "Protocol: " + model.protocol + " | Blocked by firewall rule"
                                font.pixelSize: 12
                                color: "#7f8c8d"
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: packetDetailsWindow1.showDetails1(model)
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
            }
        }

        PacketDetailsWindow {
            id: packetDetailsWindow1
        }

        GroupBox {
            title: "🔒 Active Firewall Rules (" + root.firewallRules.length + ")"
            Layout.fillWidth: true
            font.bold: true

            ColumnLayout {
                spacing: 8

                Text {
                    text: "Total Rules: " + root.firewallRules.length
                    font.pixelSize: 14
                }

                Repeater {
                    model: root.firewallRules
                    delegate: Text {
                        text: "• " + modelData.sourceIp + ":" + modelData.port +
                              " (" + modelData.protocol + ") - " + modelData.action
                        font.pixelSize: 12
                        color: modelData.action === "Block" ? "#e74c3c" : "#2ecc71"
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
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: pageStack.clear()
        }
    }
}
