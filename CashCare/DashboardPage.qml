// DashboardPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CashCare 1.0

Rectangle {
    id: dashboardPage
    visible: false
    color: "#FFFFFF"

    property NetworkSniffer sniffer

    function isBlockedByFirewall(packet) {
        for (var i = 0; i < root.firewallRules.length; i++) {
            var rule = root.firewallRules[i];
            if (rule.sourceIp === packet.source && rule.action === "Block" &&
                (rule.port === "any" || rule.port === packet.sourcePort || rule.port === packet.destinationPort)) {
                return true;
            }
        }
        return false;
    }

    Connections {
        target: sniffer
        function onPacketInfoChanged() {
            console.log("Packet Info Changed:\n" + sniffer.packetInfo);
            console.log("Risk Note: " + sniffer.riskNote);
            console.log("Total Packets: " + sniffer.totalPackets);
            var lines = sniffer.packetInfo.split("\n");
            var packet = {
                packetNumber: sniffer.totalPackets,
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
                transactionAmount: sniffer.transactionAmount,
                paymentMethod: sniffer.paymentMethod,
                failedAttempts: sniffer.failedAttempts,
                riskNote: sniffer.riskNote,
                geolocation: "",
                packetInfo: sniffer.packetInfo,
                context: "analyzing..."
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

            if (packet.riskNote.includes("High-risk country") ||
                packet.riskNote.includes("High abuse score") ||
                packet.riskNote.includes("ML Fraud Prediction: Fraud") ||
                packet.source === "185.107.70.202") {
                if (!isBlockedByFirewall(packet)) {
                    var rule = { sourceIp: packet.source, port: "any", protocol: packet.protocol || "TCP", action: "Block" };
                    root.firewallRules = root.firewallRules.concat([rule]);
                    console.log("Blocked suspicious IP:", packet.source);
                }
                blockedPacketsModel.append(packet);
                root.blockedPackets += 1;
                console.log("Added to blockedPacketsModel: Packet #" + packet.packetNumber);
                console.log("Current blockedPacketsModel count:", blockedPacketsModel.count);
            } else {
                console.log("Packet #" + packet.packetNumber + " not added to blockedPacketsModel (no fraud conditions met)");
            }
        }
        function onPacketContextUpdated(packetNumber, context) {
            console.log("DashboardPage: Received context for packet #:" + packetNumber + ": " + context);
            console.log("blockedPacketsModel count before update:", blockedPacketsModel.count);
            var found = false;
            for (var i = 0; i < blockedPacketsModel.count; i++) {
                var modelPacketNumber = blockedPacketsModel.get(i).packetNumber.toString();
                console.log("Checking packet at index", i, "with number:", modelPacketNumber);
                if (modelPacketNumber === packetNumber) {
                    blockedPacketsModel.setProperty(i, "context", context);
                    console.log("DashboardPage: Updated context at index", i);
                    // Force UI refresh
                    recentActivityList.model = null;
                    recentActivityList.model = blockedPacketsModel;
                    found = true;
                    break;
                }
            }
            if (!found) {
                console.log("DashboardPage: No matching packet found for #" + packetNumber);
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
                    Text { text: "📦 TOTAL PACKETS"; font.pixelSize: 14; color: "white" }
                    Text { text: sniffer.totalPackets; font.pixelSize: 28; font.bold: true; color: "white" }
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
                    Text { text: "🚫 BLOCKED PACKETS"; font.pixelSize: 14; color: "white" }
                    Text { text: root.blockedPackets; font.pixelSize: 28; font.bold: true; color: "white" }
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
                    Text { text: "🌐 BANDWIDTH"; font.pixelSize: 14; color: "white" }
                    Text { text: sniffer.bandwidth.toFixed(2) + " KB/s"; font.pixelSize: 28; font.bold: true; color: "white" }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 10
                color: "#f1c40f"
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "🔒 TOTAL RULES"; font.pixelSize: 14; color: "white" }
                    Text { text: root.firewallRules.length; font.pixelSize: 28; font.bold: true; color: "white" }
                }
            }
        }

        GroupBox {
            title: "🚨 Recent Blocked Fraudulent Activity"
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
                    height: 70
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
                            Layout.fillWidth: true
                            Text {
                                text: model.source + " → " + model.destination;
                                font.pixelSize: 14;
                                font.bold: true;
                                color: "#2c3e50"
                            }
                            Text {
                                text: "Protocol: " + model.protocol + " | Fraudulent Activity Blocked";
                                font.pixelSize: 12;
                                color: "#7f8c8d"
                            }
                            Text {
                                text: "Context: " + model.context;
                                font.pixelSize: 12;
                                color: "#e74c3c";
                                wrapMode: Text.Wrap;
                                Layout.fillWidth: true
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: packetDetailsWindow.showDetails1(model)
                    }
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn }
            }
        }

        PacketDetailsWindow { id: packetDetailsWindow }

        GroupBox {
            title: "🔒 Active Firewall Rules (" + root.firewallRules.length + ")"
            Layout.fillWidth: true
            font.bold: true

            ColumnLayout {
                spacing: 8
                Text { text: "Total Rules: " + root.firewallRules.length; font.pixelSize: 14 }
                Repeater {
                    model: root.firewallRules
                    delegate: Text {
                        text: "• " + modelData.sourceIp + ":" + modelData.port + " (" + modelData.protocol + ") - " + modelData.action
                        font.pixelSize: 12
                        color: modelData.action === "Block" ? "#e74c3c" : "#2ecc71"
                    }
                }
            }
        }

        Button {
            text: "⬅ Back to Main"
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle { color: "#7f8c8d"; radius: 8 }
            contentItem: Text {
                text: parent.text;
                color: "white";
                font.pixelSize: 14;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: pageStack.clear()
        }
    }

    Component.onCompleted: {
        console.log("DashboardPage loaded");
    }
}
