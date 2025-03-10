import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CashCare 1.0

Rectangle {
    id: networkSnifferPage
    visible: false
    color: "#FFFFFF"

    NetworkSniffer {
        id: sniffer
        onPacketInfoChanged: {
            var packetData = parsePacketInfo(packetInfo)
            packetModel.append(packetData)
            // root.totalPackets++ removed; handled in C++
        }
        onTransactionAmountChanged: {
            console.log("Transaction Amount:", sniffer.transactionAmount)
        }
        onPaymentMethodChanged: {
            console.log("Payment Method:", sniffer.paymentMethod)
        }
        onFailedAttemptsChanged: {
            console.log("Failed Attempts:", sniffer.failedAttempts)
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
        var geolocation = "N/A";
        var transactionAmount = "N/A";
        var paymentMethod = "N/A";
        var failedAttempts = "0";

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            if (line.startsWith("Source IP:")) {
                source = line.split(":")[1].trim();
            } else if (line.startsWith("Destination IP:")) {
                destination = line.split(":")[1].trim();
            } else if (line.startsWith("Protocol:")) {
                protocol = line.split(":")[1].trim();
            } else if (line.startsWith("Source Port:")) {
                sourcePort = line.split(":")[1].trim();
            } else if (line.startsWith("Destination Port:")) {
                destinationPort = line.split(":")[1].trim();
            } else if (line.startsWith("Payload Length:")) {
                payloadLength = line.split(":")[1].trim();
            } else if (line.startsWith("Flags:")) {
                flags = line.split(":")[1].trim();
            } else if (line.startsWith("Window Size:")) {
                windowSize = line.split(":")[1].trim();
            } else if (line.startsWith("Geolocation:")) {
                geolocation = line.split(":")[1].trim();
            } else if (line.startsWith("Transaction Amount:")) {
                transactionAmount = line.split(":")[1].trim();
            } else if (line.startsWith("Payment Method:")) {
                paymentMethod = line.split(":")[1].trim();
            } else if (line.startsWith("Failed Attempts:")) {
                failedAttempts = line.split(":")[1].trim();
            } else if (line.startsWith("Protocol Detected:")) {
                protocol = line.split(":")[1].trim();
            }
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
            transactionAmount: transactionAmount,
            paymentMethod: paymentMethod,
            failedAttempts: failedAttempts
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
                        width: 180
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
                        model: ["Source", "Destination", "Protocol", "Source Port", "Destination Port", "Payload Length", "Flags", "Window Size", "Geolocation", "Amount", "Payment", "Failed"]
                        delegate: Rectangle {
                            width: (packetListView.width - 180) / 12
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
                color: index % 2 === 0 ? "#F5F5F5" : "#E0E0E0"
                border.color: "#D0D0D0"

                Row {
                    spacing: 1
                    Rectangle {
                        width: 180
                        height: 40
                        Text {
                            text: time
                            anchors.centerIn: parent
                            font.pixelSize: 12
                            color: "#333333"
                            elide: Text.ElideRight
                        }
                    }
                    Repeater {
                        model: [source, destination, protocol, sourcePort, destinationPort, payloadLength, flags, windowSize, geolocation, transactionAmount, paymentMethod, failedAttempts]
                        delegate: Rectangle {
                            width: (packetListView.width - 180) / 12
                            height: 40
                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                font.pixelSize: 12
                                color: "#333333"
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.color = "#D0E0F0"
                    onExited: parent.color = index % 2 === 0 ? "#F5F5F5" : "#E0E0E0"
                    onClicked: {
                        packetDetailsWindow.visible = true
                        packetDetailsWindow.loadPacketDetails(model)
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }
            ScrollBar.horizontal: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }
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
