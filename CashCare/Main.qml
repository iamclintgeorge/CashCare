import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Fusion
import com.example 1.0 // Import the NetworkSniffer class

ApplicationWindow {
    id: root
    width: 1200
    height: 720
    visible: true
    title: qsTr("CashCare - Securing Transactions, one at a time")
    color: "#EAEAEA"

    // Property to store internet connection status
    property bool isConnectedToInternet: false

    // Function to check internet connection
    function checkInternetConnection() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://www.google.com", true); // Use a reliable URL to check connectivity
        xhr.timeout = 3000; // Set timeout to 3 seconds

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    isConnectedToInternet = true; // Connected to internet
                } else {
                    isConnectedToInternet = false; // Not connected to internet
                }
            }
        };

        xhr.ontimeout = function() {
            isConnectedToInternet = false; // Not connected to internet
        };

        xhr.send();
    }

    // Timer to periodically check internet connection
    Timer {
        id: internetCheckTimer
        interval: 5000 // Check every 5 seconds
        running: true
        repeat: true
        onTriggered: checkInternetConnection()
    }

    Rectangle {
        id: mainContent
        anchors.fill: parent
        color: "#EAEAEA"

        // Navbar
        Rectangle {
            id: navbardiv
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            color: "#F9F9F9"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                // Left navbar items
                RowLayout {
                    spacing: 20

                    // File menu
                    Text {
                        id: file
                        text: qsTr("File")
                        font.family: "Inter"
                        font.pointSize: 10
                        color: "#000000"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                fileMenu.visible = !fileMenu.visible;
                            }
                        }
                    }

                    Text {
                        text: qsTr("Edit")
                        font.family: "Arial"
                        font.pointSize: 10
                        color: "#000000"
                    }

                    Text {
                        text: qsTr("View")
                        font.family: "Arial"
                        font.pointSize: 10
                        color: "#000000"
                    }

                    Text {
                        text: qsTr("Help")
                        font.family: "Arial"
                        font.pointSize: 10
                        color: "#000000"
                    }
                }

                // Spacer
                Item { Layout.fillWidth: true }

                // Search bar in the middle
                TextField {
                    id: searchBar
                    Layout.fillWidth: true
                    placeholderText: qsTr("Search...")
                    font.family: "Arial"
                    font.pointSize: 10
                    leftPadding: 30
                    background: Rectangle {
                        color: "#FFFFFF"
                        radius: 15
                        Image {
                            source: "images/search.png" // Search icon
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            width: 16
                            height: 16
                        }
                    }
                }

                // Right navbar items (icons for settings, notifications, and profile)
                RowLayout {
                                    spacing: 0

                                    Button {
                                        icon.source: "images/settings.png" // Settings icon
                                        icon.width: 20
                                        icon.height: 20
                                        flat: true
                                        onClicked: console.log("Settings clicked")
                                    }

                                    Button {
                                        icon.source: "images/notification.png" // Notification icon
                                        icon.width: 20
                                        icon.height: 20
                                        flat: true
                                        onClicked: console.log("Notifications clicked")
                                    }

                                    Button {
                                        icon.source: "images/profile.png" // Profile icon
                                        icon.width: 20
                                        icon.height: 20
                                        flat: true
                                        onClicked: changer.push("Login.qml")
                                    }
                                }

                            }

            // File menu popup
            Rectangle {
                id: fileMenu
                width: 150
                height: 30 // Height for a single option
                visible: false
                color: "#FFFFFF"
                border.color: "#E6E6E6"
                anchors.top: file.bottom // Position below the "File" text
                anchors.left: file.left
                anchors.topMargin: 5 // Small margin to avoid overlapping
                z: 100 // Ensure the menu is on top of other elements

                // Prevent clicks from propagating to underlying elements
                MouseArea {
                    anchors.fill: parent
                    onClicked: {} // Do nothing, just block clicks
                }

                // Exit option
                Rectangle {
                    anchors.fill: parent
                    color: fileMenuExitArea.containsMouse ? "#E6E6E6" : "#FFFFFF"

                    Text {
                        anchors.centerIn: parent
                        text: "Exit"
                        font.family: "Arial"
                        font.pointSize: 10
                        color: "#000000"
                    }

                    MouseArea {
                        id: fileMenuExitArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Qt.quit()
                    }
                }
            }

            // Navbar bottom border
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "#E6E6E6"
            }
        }

        // Sidebar
        Rectangle {
            id: sidebardiv
            anchors.top: navbardiv.bottom
            anchors.bottom: statusbardiv.top
            anchors.left: parent.left
            width: 250
            color: "#F9F9F9"

            ColumnLayout {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 35

                // Dashboard with icon
                RowLayout {
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                    spacing: 10

                    Image {
                        source: "images/dashboard.png" // Dashboard icon
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                    }

                    Text {
                        text: qsTr("Dashboard")
                        font.family: "Arial"
                        font.pointSize: 10.5
                    }
                }

                // Firewall ruleset with icon
                RowLayout {
                    Layout.leftMargin: 50
                    spacing: 10

                    Image {
                        source: "images/firewall.png" // Firewall icon
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                    }

                    Text {
                        text: qsTr("Firewall ruleset")
                        font.family: "Arial"
                        font.pointSize: 10.5
                    }
                }

                // Check networks with icon
                RowLayout {
                    Layout.leftMargin: 50
                    spacing: 10

                    Image {
                        source: "images/network.png" // Network icon
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                    }

                    Text {
                        text: qsTr("Check networks")
                        font.family: "Arial"
                        font.pointSize: 10.5
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // Show the network sniffer page
                                networkSnifferPage.visible = true;
                            }
                        }
                    }
                }

                // Log history with icon
                RowLayout {
                    Layout.leftMargin: 50
                    spacing: 10

                    Image {
                        source: "images/log.png" // Log icon
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                    }

                    Text {
                        text: qsTr("Log history")
                        font.family: "Arial"
                        font.pointSize: 10.5
                    }
                }
            }
        }

        // Status bar
        Rectangle {
            id: statusbardiv
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 25
            color: "#F9F9F9"

            // Status bar top border
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "#E6E6E6"
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5

                // Left status items
                RowLayout {
                    spacing: 10
                    Layout.leftMargin: 15

                    Text {
                        text: qsTr("Layout")
                        font.family: "Arial"
                        font.pointSize: 8
                        color: "#757575"
                    }

                    Text {
                        text: isConnectedToInternet ? "Connected to Internet" : "Not Connected to Internet"
                        font.family: "Arial"
                        font.pointSize: 8
                        color: isConnectedToInternet ? "#757575" : "#FF0000" // Red color for not connected
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                // Right status items
                Text {
                    text: qsTr("Help")
                    font.family: "Arial"
                    font.pointSize: 8
                    color: "#757575"
                    Layout.rightMargin: 15
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Status bar clicked")
                }
            }
        }

        // Network Sniffer Page (initially hidden)
        Rectangle {
            id: networkSnifferPage
            anchors.fill: parent
            visible: false
            color: "#FFFFFF"

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                // Header
                Text {
                    text: "Network Sniffer"
                    font.family: "Arial"
                    font.pointSize: 20
                    Layout.alignment: Qt.AlignHCenter
                }

                // Table header
                Row {
                    spacing: 1
                    Repeater {
                        model: ["Time", "Source", "Destination", "Protocol", "Source Port", "Destination Port", "Payload Length", "Flags", "Window Size", "Geolocation"]
                        delegate: Rectangle {
                            width: 120
                            height: 30
                            color: "#F0F0F0"
                            border.color: "#E0E0E0"

                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                font.bold: true
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                // Table view to display captured packets
                ListView {
                    id: packetListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: ListModel {
                        id: packetModel
                    }
                    delegate: Rectangle {
                        width: packetListView.width
                        height: 30
                        color: index % 2 === 0 ? "#F9F9F9" : "#FFFFFF"
                        border.color: "#E0E0E0"

                        Row {
                            spacing: 1
                            Repeater {
                                model: [time, source, destination, protocol, sourcePort, destinationPort, payloadLength, flags, windowSize, geolocation]
                                delegate: Rectangle {
                                    width: 120
                                    height: 30

                                    Text {
                                        text: modelData
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }

                        // Handle row clicks
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // Open detailed packet view
                                packetDetailsWindow.visible = true;
                                packetDetailsWindow.loadPacketDetails(model)
                            }
                        }
                    }
                }

                // Back button
                Button {
                    text: "Back"
                    font.family: "Arial"
                    font.pointSize: 12
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: {
                        networkSnifferPage.visible = false;
                    }
                }
            }
        }

        // Detailed packet view window
        Window {
            id: packetDetailsWindow
            width: 600
            height: 400
            title: "Packet Details"
            visible: false

            property var packetData: null


            function loadPacketDetails(packet) {
                packetData = packet
                detailsText.text = `
                    <b>Time:</b> ${packet.time}<br>
                    <b>Source:</b> ${packet.source}<br>
                    <b>Destination:</b> ${packet.destination}<br>
                    <b>Protocol:</b> ${packet.protocol}<br>
                    <b>Source Port:</b> ${packet.sourcePort}<br>
                    <b>Destination Port:</b> ${packet.destinationPort}<br>
                    <b>Payload Length:</b> ${packet.payloadLength}<br>
                    <b>Flags:</b> ${packet.flags}<br>
                    <b>Window Size:</b> ${packet.windowSize}<br>
                    <b>Geolocation:</b> ${packet.geolocation}<br>
                `
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
                    onClicked: packetDetailsWindow.close()
                }
            }
        }

        // Network Sniffer Component
        NetworkSniffer {
            id: networkSniffer
            onPacketInfoChanged: {
                // Print the packetInfo string for debugging
                console.log("Packet Info:", packetInfo)

                // Parse packet info and add to the table model
                var packetDetails = parsePacketInfo(packetInfo)
                packetModel.append(packetDetails)
            }

            function parsePacketInfo(packetInfo) {
                // Split the packetInfo string into lines
                var lines = packetInfo.split("\n")

                // Extract relevant fields
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
                    } else if (line.startsWith("Geolocation")) {
                        geolocation = line.split(":")[1].trim()
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
                    geolocation: geolocation
                }
            }
        }


        // Function to filter packets based on search text
               function filterPackets() {
                   var searchText = searchBar.text.toLowerCase()
                   packetModel.clear()
                   for (var i = 0; i < networkSniffer.packets.length; i++) {
                       var packet = networkSniffer.packets[i]
                       if (packet.source.toLowerCase().includes(searchText) ||
                           packet.destination.toLowerCase().includes(searchText) ||
                           packet.protocol.toLowerCase().includes(searchText)) {
                           packetModel.append(packet)
                       }
                   }
               }

               // Function to export packet data to JSON
               function exportPacketData() {
                   var packetData = []
                   for (var i = 0; i < packetModel.count; i++) {
                       packetData.push(packetModel.get(i))
                   }
                   var jsonData = JSON.stringify(packetData, null, 2)
                   var filePath = "packet_data.json"
                   var file = Qt.openUrlExternally("file:///" + filePath)
                   file.write(jsonData)
                   file.close()
                   console.log("Packet data exported to " + filePath)
               }
    }
}
