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

        // Table Container with proper scrolling
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: "#D0D0D0"

            ScrollView {
                id: tableScrollView
                anchors.fill: parent
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                Item {
                    // Make this wider than the view to allow horizontal scrolling
                    width: Math.max(1400, tableScrollView.width)
                    height: headerRect.height + packetListView.contentHeight

                    // Fixed header
                    Rectangle {
                        id: headerRect
                        width: parent.width
                        height: 40
                        color: "#4A90E2"

                        Row {
                            anchors.fill: parent

                            // Column headers with fixed widths
                            Rectangle {
                                width: 120
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Time"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 120
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Source"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 120
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Destination"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 100
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Protocol"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 100
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Source Port"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 100
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Dest Port"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 80
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Length"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 140
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Geolocation"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 100
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Threat"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 100
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Amount"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 100
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Payment"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 80
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Failed"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Rectangle {
                                width: 240
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Risk Note"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }

                    // Data rows
                    ListView {
                        id: packetListView
                        anchors.top: headerRect.bottom
                        width: parent.width
                        height: tableScrollView.height - headerRect.height
                        model: ListModel { id: packetModel }
                        clip: true

                        delegate: Rectangle {
                            width: packetListView.width
                            height: 40
                            // Always white background unless fraudulent
                            color: {
                                if (riskNote && riskNote.includes("ML Fraud Prediction: Fraud")) {
                                    return "#FFEBEE";  // Light red for fraudulent
                                } else {
                                    return "#FFFFFF";  // White for all other rows
                                }
                            }
                            border.color: "#D0D0D0"

                            Row {
                                anchors.fill: parent

                                // Time column
                                Rectangle {
                                    width: 120
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: time
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Source IP column
                                Rectangle {
                                    width: 120
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: source
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Destination IP column
                                Rectangle {
                                    width: 120
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: destination
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Protocol column
                                Rectangle {
                                    width: 100
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: protocol
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Source Port column
                                Rectangle {
                                    width: 100
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: sourcePort
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Destination Port column
                                Rectangle {
                                    width: 100
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: destinationPort
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Length column
                                Rectangle {
                                    width: 80
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: payloadLength
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Geolocation column
                                Rectangle {
                                    width: 140
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: geolocation
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                        elide: Text.ElideRight
                                    }
                                }

                                // Threat Level column
                                Rectangle {
                                    width: 100
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: threatLevel
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: {
                                            if (threatLevel === "High") return "#FF5252";
                                            if (threatLevel === "Medium") return "#FFA726";
                                            return "#333333";
                                        }
                                    }
                                }

                                // Transaction Amount column
                                Rectangle {
                                    width: 100
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: transactionAmount
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Payment Method column
                                Rectangle {
                                    width: 100
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: paymentMethod
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Failed Attempts column
                                Rectangle {
                                    width: 80
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: failedAttempts
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333"
                                    }
                                }

                                // Risk Note column
                                Rectangle {
                                    width: 240
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: riskNote
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: riskNote && riskNote.includes("Fraud") ? "#FF5252" : "#333333"
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = riskNote && riskNote.includes("ML Fraud Prediction: Fraud") ? "#FFD6D6" : "#F5F5F5"
                                onExited: parent.color = riskNote && riskNote.includes("ML Fraud Prediction: Fraud") ? "#FFEBEE" : "#FFFFFF"
                                onClicked: {
                                    packetDetailsWindow.visible = true;
                                    packetDetailsWindow.loadPacketDetails(model);
                                }
                            }
                        }
                    }
                }
            }
        }

        Button {
            text: "Back"
            font.family: "Arial"
            font.pointSize: 12
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            onClicked: pageStack.replace(dashboardPage)
        }
    }

    PacketDetailsWindow {
        id: packetDetailsWindow
    }
}
