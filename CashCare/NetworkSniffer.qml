// NetworkSniffer.qml
import QtQuick

Item {
    id: networkSniffer

    signal packetInfoChanged(string packetInfo)

    function parsePacketInfo(packetInfo) {
        var lines = packetInfo.split("\n")
        var time = new Date().toLocaleTimeString()
        var source = "N/A"
        var destination = "N/A"
        var protocol = "N/A"
        var sourcePort = "N/A"
        var destinationPort = "N/A"
        var payloadLength = "N/A"
        var flags = "N/A"
        var windowSize = "N/A"
        var geolocation = "N/A"
        var failedAttempts = "N/A"
        var transactionHour = "N/A"
        var isWeekend = "N/A"

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.startsWith("Source IP:")) {
                source = line.split(":")[1].trim()
            } else if (line.startsWith("Destination IP:")) {
                destination = line.split(":")[1].trim()
            } else if (line.startsWith("Protocol:")) {
                protocol = line.split(":")[1].trim()
            } else if (line.startsWith("Source Port:")) {
                sourcePort = line.split(":")[1].trim()
            } else if (line.startsWith("Destination Port:")) {
                destinationPort = line.split(":")[1].trim()
            } else if (line.startsWith("Payload Length:")) {
                payloadLength = line.split(":")[1].trim()
            } else if (line.startsWith("Flags:")) {
                flags = line.split(":")[1].trim()
            } else if (line.startsWith("Window Size:")) {
                windowSize = line.split(":")[1].trim()
            } else if (line.startsWith("Geolocation:")) {
                geolocation = line.split(":")[1].trim()
            } else if (line.startsWith("Failed Attempts:")) {
                failedAttempts = line.split(":")[1].trim()
            } else if (line.startsWith("Transaction Hour:")) {
                transactionHour = line.split(":")[1].trim()
            } else if (line.startsWith("Is Weekend:")) {
                isWeekend = line.split(":")[1].trim()
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
            failedAttempts: failedAttempts,
            transactionHour: transactionHour,
            isWeekend: isWeekend
        }
    }

    // Placeholder properties - these would typically be implemented in C++
    property int totalPackets: 0
    property int blockedPackets: 0
    property real bandwidthUsage: 0.0
    property var firewallRules: []
    property int firewallRulesCount: firewallRules.length
    property var packets: []

    function addFirewallRule(ip, port, protocol, action) {
        // Implementation would go here
    }

    function removeFirewallRule(index) {
        // Implementation would go here
    }
}
