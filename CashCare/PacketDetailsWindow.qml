import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 600
    height: 700
    title: "Packet Details"
    visible: false
    color: "#F8F9FA"

    property var model: null

    // Alias for compatibility with old code
    function showDetails1(packet) {
        loadPacketDetails(packet)
    }

    function loadPacketDetails(packetModel) {
        model = packetModel;

        // Update the map if geolocation is available
        if (model.geolocation && model.geolocation !== "N/A") {
            mapImage.visible = true;
            geoText.text = "Location: " + model.geolocation;
        } else {
            mapImage.visible = false;
            geoText.text = "Location data unavailable";
        }

        // Update ML prediction section visibility
        mlPredictionSection.visible = model.riskNote && model.riskNote.includes("ML Fraud Prediction");
    }

    ScrollView {
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn // Ensures vertical scrollbar is always visible

        ColumnLayout {
            width: root.width - 40 // Account for margins
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Packet #" + (model ? model.packetNumber : "")
                font.pixelSize: 20
                font.bold: true
            }

            // Ethernet Header
            GroupBox {
                title: "Ethernet Header"
                Layout.fillWidth: true

                GridLayout {
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 15
                    Layout.fillWidth: true

                    Text { text: "Source MAC:"; font.bold: true }
                    Text { text: model ? (model.sourceMac || "N/A") : "" }

                    Text { text: "Destination MAC:"; font.bold: true }
                    Text { text: model ? (model.destMac || "N/A") : "" }
                }
            }

            // IP Header and Basic Information
            GroupBox {
                title: "IP Header and Basic Information"
                Layout.fillWidth: true

                GridLayout {
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 15
                    Layout.fillWidth: true

                    Text { text: "Time:"; font.bold: true }
                    Text { text: model ? (model.time || "N/A") : "" }

                    Text { text: "Source IP:"; font.bold: true }
                    Text { text: model ? (model.source || "N/A") : "" }

                    Text { text: "Destination IP:"; font.bold: true }
                    Text { text: model ? (model.destination || "N/A") : "" }

                    Text { text: "Protocol:"; font.bold: true }
                    Text { text: model ? (model.protocol || "N/A") : "" }

                    Text { text: "Payload Length:"; font.bold: true }
                    Text { text: model ? (model.payloadLength || "0") : "" }
                }
            }

            // TCP/UDP Header
            GroupBox {
                title: "Transport Header"
                Layout.fillWidth: true

                GridLayout {
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 15
                    Layout.fillWidth: true

                    Text { text: "Source Port:"; font.bold: true }
                    Text { text: model ? (model.sourcePort || "N/A") : "" }

                    Text { text: "Destination Port:"; font.bold: true }
                    Text { text: model ? (model.destinationPort || "N/A") : "" }

                    Text { text: "Flags:"; font.bold: true }
                    Text { text: model ? (model.flags || "N/A") : "" }

                    Text { text: "Window Size:"; font.bold: true }
                    Text { text: model ? (model.windowSize || "N/A") : "" }

                    Text { text: "Protocol Detected:"; font.bold: true }
                    Text { text: model ? (model.protocolDetected || "N/A") : "" }
                }
            }

            // Geolocation Section
            GroupBox {
                title: "Geolocation"
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    Text {
                        id: geoText
                        text: "Location data unavailable"
                    }

                    Image {
                        id: mapImage
                        source: "qrc:/images/map_placeholder.png"  // Provide this image
                        Layout.preferredWidth: 400
                        Layout.preferredHeight: 200
                        Layout.alignment: Qt.AlignCenter
                        visible: false

                        Text {
                            anchors.centerIn: parent
                            text: "Map visualization would appear here\nUsing data: " + (model ? model.geolocation : "")
                            horizontalAlignment: Text.AlignHCenter
                            color: "#555555"
                        }
                    }

                    Text {
                        text: "Threat Level: " + (model ? (model.threatLevel || "N/A") : "N/A")
                        color: {
                            if (model && model.threatLevel === "High") return "#FF5252";
                            if (model && model.threatLevel === "Medium") return "#FFA726";
                            return "#66BB6A";
                        }
                        font.bold: true
                    }
                }
            }

            // Financial Information
            GroupBox {
                title: "Financial Information"
                Layout.fillWidth: true
                visible: model && (model.transactionAmount !== "N/A" || parseInt(model.failedAttempts) > 0)

                GridLayout {
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 15
                    Layout.fillWidth: true

                    Text { text: "Transaction Amount:"; font.bold: true }
                    Text { text: model ? (model.transactionAmount || "N/A") : "" }

                    Text { text: "Payment Method:"; font.bold: true }
                    Text { text: model ? (model.paymentMethod || "N/A") : "" }

                    Text { text: "Failed Attempts:"; font.bold: true }
                    Text {
                        text: model ? (model.failedAttempts || "0") : ""
                        color: model && parseInt(model.failedAttempts) > 0 ? "#FF5252" : "#333333"
                    }
                }
            }

            // ML Prediction Section
            Rectangle {
                id: mlPredictionSection
                Layout.fillWidth: true
                height: 100
                color: "#F8F9FA"
                border.color: "#DEE2E6"
                visible: model && model.riskNote && model.riskNote.includes("ML Fraud Prediction")
                radius: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text {
                        text: "Machine Learning Analysis"
                        font.bold: true
                        font.pixelSize: 16
                    }

                    Text {
                        text: {
                            if (model && model.riskNote && model.riskNote.includes("ML Fraud Prediction")) {
                                var parts = model.riskNote.split(";");
                                for (var i = 0; i < parts.length; i++) {
                                    if (parts[i].includes("ML Fraud Prediction")) {
                                        return parts[i].trim();
                                    }
                                }
                            }
                            return "No ML prediction available";
                        }
                        font.pixelSize: 14
                        color: text.includes("Fraud") && !text.includes("Non-Fraud") ? "#DC3545" : "#28A745"
                    }

                    ProgressBar {
                        Layout.fillWidth: true
                        from: 0
                        to: 1
                        value: {
                            if (model && model.riskNote && model.riskNote.includes("Prob:")) {
                                var probStart = model.riskNote.indexOf("Prob:") + 6;
                                var probEnd = model.riskNote.indexOf(")", probStart);
                                if (probEnd === -1) probEnd = model.riskNote.indexOf(";", probStart);
                                if (probEnd === -1) probEnd = model.riskNote.length;
                                var probText = model.riskNote.substring(probStart, probEnd).trim();
                                return parseFloat(probText);
                            }
                            return 0;
                        }

                        background: Rectangle {
                            implicitWidth: 200
                            implicitHeight: 6
                            color: "#E0E0E0"
                            radius: 3
                        }

                        contentItem: Rectangle {
                            width: parent.width * parent.visualPosition
                            height: parent.height
                            radius: 2
                            color: parent.value >= 0.7 ? "#DC3545" : (parent.value >= 0.3 ? "#FFC107" : "#28A745")
                        }
                    }
                }
            }

            // AI Analysis (LLM Context)
            GroupBox {
                title: "AI Analysis"
                Layout.fillWidth: true
                visible: model && model.context && model.context !== "analyzing"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: model ? (model.context || "Waiting for LLM...") : ""
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            // Risk Analysis
            GroupBox {
                title: "Risk Analysis"
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: model ? (model.riskNote || "No risks detected") : ""
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            // Actions Section
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 15

                Button {
                    text: "Block IP"
                    onClicked: {
                        if (model && model.source && model.source !== "N/A") {
                            var rule = {
                                sourceIp: model.source,
                                port: "*",
                                protocol: "ALL",
                                action: "Block"
                            };
                            var newRules = root.firewallRules ? root.firewallRules.slice() : [];
                            newRules.push(rule);
                            root.firewallRules = newRules;
                            // Add notification logic here if needed
                        }
                    }
                }

                Button {
                    text: "Flag as Fraud"
                    onClicked: {
                        // Add logic to flag transaction as fraudulent
                    }
                }

                Button {
                    text: "Close"
                    onClicked: root.visible = false
                }
            }
        }
    }
}
