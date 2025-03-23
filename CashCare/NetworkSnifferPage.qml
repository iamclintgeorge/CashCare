// NetworkSnifferPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CashCare 1.0

Rectangle {
    id: networkSnifferPage
    visible: false
    color: "#FFFFFF"

    property NetworkSniffer sniffer  // Accept shared instance

    Connections {
        target: sniffer
        function onPacketInfoChanged() {
            var packetData = parsePacketInfo(sniffer.packetInfo);
            packetData.riskNote = sniffer.riskNote;
            packetData.packetNumber = sniffer.totalPackets;
            packetData.geolocation = sniffer.geoInfo || "N/A";
            packetData.threatLevel = sniffer.threatLevel || "N/A";
            packetModel.append(packetData);
        }
        function onTransactionAmountChanged() {
            console.log("Transaction Amount:", sniffer.transactionAmount);
        }
        function onPaymentMethodChanged() {
            console.log("Payment Method:", sniffer.paymentMethod);
        }
        function onFailedAttemptsChanged() {
            console.log("Failed Attempts:", sniffer.failedAttempts);
        }
        function onGeoInfoChanged() {
            console.log("Geolocation Info:", sniffer.geoInfo);
            // Update the most recent packet with the new geo info
            if (packetModel.count > 0) {
                packetModel.setProperty(packetModel.count - 1, "geolocation", sniffer.geoInfo);
            }
        }
        function onThreatLevelChanged() {
            console.log("Threat Level:", sniffer.threatLevel);
            // Update the most recent packet with the new threat level
            if (packetModel.count > 0) {
                packetModel.setProperty(packetModel.count - 1, "threatLevel", sniffer.threatLevel);
            }
        }
        function onPacketContextUpdated(packetInfo, context) {
            console.log("NetworkSnifferPage: Updated context for packet #" + packetInfo + ": " + context);
            for (var i = 0; i < packetModel.count; i++) {
                if (packetModel.get(i).packetNumber === parseInt(packetInfo)) {
                    packetModel.setProperty(i, "context", context);
                    break;
                }
            }
        }
    }

    function parsePacketInfo(packetInfo) {
        var lines = packetInfo.split("\n");
        var time = new Date().toLocaleTimeString();
        var source = "N/A";
        var destination = "N/A";
        var protocol = "N/A";
        var sourcePort = "N/A";
        var destinationPort = "N/A";
        var payloadLength = "N/A";
        var flags = "N/A";
        var windowSize = "N/A";
        var geolocation = sniffer.geoInfo || "N/A";
        var threatLevel = sniffer.threatLevel || "N/A";
        var transactionAmount = "N/A";
        var paymentMethod = "N/A";
        var failedAttempts = "0";
        var riskNote = sniffer.riskNote;

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            if (line.startsWith("Source IP:")) source = line.split(":")[1].trim();
            else if (line.startsWith("Destination IP:")) destination = line.split(":")[1].trim();
            else if (line.startsWith("Protocol:")) protocol = line.split(":")[1].trim();
            else if (line.startsWith("Source Port:")) sourcePort = line.split(":")[1].trim();
            else if (line.startsWith("Destination Port:")) destinationPort = line.split(":")[1].trim();
            else if (line.startsWith("Payload Length:")) payloadLength = line.split(":")[1].trim();
            else if (line.startsWith("Flags:")) flags = line.split(":")[1].trim();
            else if (line.startsWith("Window Size:")) windowSize = line.split(":")[1].trim();
            else if (line.startsWith("Transaction Amount:")) transactionAmount = line.split(":")[1].trim();
            else if (line.startsWith("Payment Method:")) paymentMethod = line.split(":")[1].trim();
            else if (line.startsWith("Failed Attempts:")) failedAttempts = line.split(":")[1].trim();
            else if (line.startsWith("Protocol Detected:")) protocol = line.split(":")[1].trim();
        }

        return {
            time: time,
            source: source,
            destination: destination,
            protocol: protocol,
            sourcePort: sourcePort,
            destinationPort: destinationPort,
            payloadLength: payloadLength,
            flags: flags,
            windowSize: windowSize,
            geolocation: geolocation,
            threatLevel: threatLevel,
            transactionAmount: transactionAmount,
            paymentMethod: paymentMethod,
            failedAttempts: failedAttempts,
            riskNote: riskNote,
            packetNumber: sniffer.totalPackets,
            context: "analyzing"  // Initial value
        };
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Text {
            text: "Network Sniffer"
            font.family: "Arial"
            font.pointSize: 20
            Layout.alignment: Qt.AlignHCenter
        }

        // Network stats summary
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#EBF5FB"
            radius: 4
            border.color: "#AED6F1"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                ColumnLayout {
                    Text {
                        text: "Total Packets"
                        font.bold: true
                    }
                    Text {
                        text: sniffer.totalPackets
                        font.pixelSize: 16
                    }
                }

                ColumnLayout {
                    Text {
                        text: "Bandwidth"
                        font.bold: true
                    }
                    Text {
                        text: (sniffer.bandwidth / 1024).toFixed(2) + " KB/s"
                        font.pixelSize: 16
                    }
                }

                ColumnLayout {
                    Text {
                        text: "Latest Threat Level"
                        font.bold: true
                    }
                    Text {
                        text: sniffer.threatLevel || "N/A"
                        font.pixelSize: 16
                        color: {
                            if (sniffer.threatLevel === "High") return "#FF5252";
                            if (sniffer.threatLevel === "Medium") return "#FFA726";
                            return "#66BB6A";
                        }
                    }
                }
            }
        }

        ListView {
            id: packetListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 1

            header: Rectangle {
                width: packetListView.width
                height: 40
                color: "#4A90E2"
                Row {
                    spacing: 1
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"
                        Text {
                            text: "Time"
                            anchors.centerIn: parent
                            font.pixelSize: 14
                            font.bold: true
                            color: "#FFFFFF"
                            elide: Text.ElideRight
                        }
                    }
                    Repeater {
                        model: ["Source", "Destination", "Protocol", "Source Port", "Dest Port",
                                "Length", "Geolocation", "Threat", "Amount",
                                "Payment", "Failed", "Risk Note"]
                        delegate: Rectangle {
                            width: (packetListView.width - 160) / 12
                            height: 40
                            color: "transparent"
                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                font.pixelSize: 14
                                font.bold: true
                                color: "#FFFFFF"
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }

            model: ListModel {
                id: packetModel
            }

            delegate: Rectangle {
                width: packetListView.width
                height: 40
                color: {
                    // Highlight fraudulent transactions
                    if (riskNote && riskNote.includes("ML Fraud Prediction: Fraud")) {
                        return "#FFEBEE"; // Light red background for fraudulent transactions
                    } else {
                        return index % 2 === 0 ? "#F5F5F5" : "#E0E0E0";
                    }
                }
                border.color: "#D0D0D0"

                Row {
                    spacing: 1
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"
                        Text {
                            text: time
                            anchors.centerIn: parent
                            font.pixelSize: 12
                            color: "#333333"
                            elide: Text.ElideRight
                        }
                    }
                    Repeater {
                        model: [source, destination, protocol, sourcePort, destinationPort, payloadLength,
                                geolocation, threatLevel, transactionAmount, paymentMethod, failedAttempts, riskNote]
                        delegate: Rectangle {
                            width: (packetListView.width - 160) / 12
                            height: 40
                            color: "transparent"
                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                font.pixelSize: 12
                                color: {
                                    if (index === 7 && modelData === "High") return "#FF5252"; // Threat level
                                    if (index === 7 && modelData === "Medium") return "#FFA726";
                                    if (index === 11 && modelData.includes("Fraud")) return "#FF5252"; // Risk note
                                    return "#333333";
                                }
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.color = riskNote && riskNote.includes("ML Fraud Prediction: Fraud") ? "#FFD6D6" : "#D0E0F0"
                    onExited: parent.color = riskNote && riskNote.includes("ML Fraud Prediction: Fraud") ? "#FFEBEE" : (index % 2 === 0 ? "#F5F5F5" : "#E0E0E0")
                    onClicked: {
                        packetDetailsWindow.visible = true;
                        packetDetailsWindow.loadPacketDetails(model);
                    }
                }
            }

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn }
            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOn }
        }

        Button {
            text: "Back"
            font.family: "Arial"
            font.pointSize: 12
            Layout.alignment: Qt.AlignHCenter
            onClicked: pageStack.replace(dashboardPage)
        }
    }

    PacketDetailsWindow {
        id: packetDetailsWindow
    }
}
