import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: packetDetailsWindow
    width: 600
    height: 400
    title: "Packet Details"
    visible: false

    property var packetData: null

    function showDetails1(packet) {
        loadPacketDetails(packet) // Alias to maintain compatibility
    }

    function loadPacketDetails(packet) {
        packetData = packet
        var details = "<h2>Captured IP Packet #" + packet.packetNumber + "</h2>";

        // Ethernet Header
        details += "<h3>Ethernet Header:</h3>";
        details += "<b>Source MAC:</b> " + (packet.sourceMac || "N/A") + "<br>";
        details += "<b>Destination MAC:</b> " + (packet.destMac || "N/A") + "<br>";

        // IP Header
        details += "<h3>IP Header:</h3>";
        details += "<b>Source IP:</b> " + (packet.source || "N/A") + "<br>";
        details += "<b>Destination IP:</b> " + (packet.destination || "N/A") + "<br>";
        details += "<b>Protocol:</b> " + (packet.protocol || "N/A") + "<br>";

        // TCP Header (assuming TCP since your example uses it)
        details += "<h3>TCP Header:</h3>";
        details += "<b>Source Port:</b> " + (packet.sourcePort || "N/A") + "<br>";
        details += "<b>Destination Port:</b> " + (packet.destinationPort || "N/A") + "<br>";
        details += "<b>Flags:</b> " + (packet.flags || "N/A") + "<br>";
        details += "<b>Window Size:</b> " + (packet.windowSize || "N/A") + "<br>";

        // Protocol Detected
        details += "<b>Protocol Detected:</b> " + (packet.protocolDetected || "N/A") + "<br>";

        // Payload Length
        details += "<b>Payload Length:</b> " + (packet.payloadLength || "0") + "<br>";

        // Additional Data
        details += "<h3>Additional Data:</h3>";
        details += "<b>Transaction Amount:</b> " + (packet.transactionAmount || "N/A") + "<br>";
        details += "<b>Payment Method:</b> " + (packet.paymentMethod || "N/A") + "<br>";
        details += "<b>Failed Attempts:</b> " + (packet.failedAttempts || "0") + "<br>";

        // Risk Analysis
        details += "<h3>Risk Analysis:</h3>";
        details += (packet.riskNote || "No risks detected") + "<br>";

        // Geolocation (if available)
        if (packet.geolocation) {
            details += "<b>Geolocation:</b> " + packet.geolocation + "<br>";
        }

        detailsText.text = details;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                id: detailsText
                font.pixelSize: 14
                wrapMode: Text.Wrap
                textFormat: Text.RichText
            }
        }

        Button {
            text: "Close"
            onClicked: packetDetailsWindow.visible = false
            Layout.alignment: Qt.AlignRight
        }
    }
}
