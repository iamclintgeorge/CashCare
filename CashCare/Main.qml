import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCharts 2.3
import QtQuick.Window
import QtQuick.Controls.Fusion
import com.example 1.0
import QtQml

pragma ComponentBehavior: Bound

ApplicationWindow {
    id: root
    width: 1200
    height: 720
    visible: true
    title: qsTr("CashCare - Securing Transactions, one at a time")
    color: "#EAEAEA"

    property bool isConnectedToInternet: false
    property var whitelist: []
    property var blacklist: []
    property var firewallRules: []
    property int totalPackets: 0
    property int blockedPackets: 0
    property real bandwidthUsage: 0.0

    function checkInternetConnection() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://www.google.com", true)
        xhr.timeout = 3000

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.isConnectedToInternet = xhr.status === 200
            }
        }

        xhr.ontimeout = function() {
            root.isConnectedToInternet = false
        }

        xhr.send()
    }

    Timer {
        id: internetCheckTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.checkInternetConnection()
    }

    function isIpAllowed(ip) {
        if (root.whitelist.length > 0) {
            return root.whitelist.includes(ip)
        } else if (root.blacklist.length > 0) {
            return !root.blacklist.includes(ip)
        }
        return true
    }

    function addToWhitelist(ip) {
        if (!root.whitelist.includes(ip)) {
            root.whitelist.push(ip)
        }
    }

    function addToBlacklist(ip) {
        if (!root.blacklist.includes(ip)) {
            root.blacklist.push(ip)
        }
    }

    function removeFromWhitelist(ip) {
        root.whitelist = root.whitelist.filter(item => item !== ip)
    }

    function removeFromBlacklist(ip) {
        root.blacklist = root.blacklist.filter(item => item !== ip)
    }

    Rectangle {
        id: mainContent
        anchors.fill: parent
        color: "#EAEAEA"

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

                RowLayout {
                    spacing: 20

                    Text {
                        id: file
                        text: qsTr("File")
                        font.family: "Inter"
                        font.pointSize: 10
                        color: "#000000"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: fileMenu.visible = !fileMenu.visible
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

                Item { Layout.fillWidth: true }

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
                            source: "images/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            width: 16
                            height: 16
                        }
                    }
                }

                RowLayout {
                    spacing: 10

                    Button {
                        icon.source: "images/settings.png"
                        icon.width: 24
                        icon.height: 24
                        flat: true
                        onClicked: console.log("Settings clicked")
                    }

                    Button {
                        icon.source: "images/notification.png"
                        icon.width: 24
                        icon.height: 24
                        flat: true
                        onClicked: console.log("Notifications clicked")
                    }

                    Button {
                        icon.source: "images/profile.png"
                        icon.width: 24
                        icon.height: 24
                        flat: true
                        onClicked: Qt.openUrlExternally("https://localhost:3000/login")
                    }
                }
            }

            Rectangle {
                id: fileMenu
                Layout.preferredWidth: 150
                Layout.preferredHeight: 30
                visible: false
                color: "#FFFFFF"
                border.color: "#E6E6E6"
                anchors.top: file.bottom
                anchors.left: file.left
                anchors.topMargin: 5
                z: 100

                MouseArea {
                    anchors.fill: parent
                    onClicked: {}
                }

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

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "#E6E6E6"
            }
        }


        property var firewallRules: []
        property int totalPackets: 0
        property int blockedPackets: 0
        property real bandwidthUsage: 0.0


        // Dashboard Page
        Rectangle {
            id: dashboardPage
            anchors.top: navbardiv.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: true
            color: "#FFFFFF"
            z: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 15
                anchors.margins: 20

                // Header
                Text {
                    text: "Network Security Dashboard"
                    font.family: "Arial"
                    font.bold: true
                    font.pointSize: 24
                    color: "#2c3e50"
                    Layout.alignment: Qt.AlignHCenter
                }

                // Statistics Cards
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    // Total Packets Card
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

                    // Blocked Packets Card
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
                                text: networkSniffer.blockedPackets
                                font.pixelSize: 28
                                font.bold: true
                                color: "white"
                            }
                        }
                    }

                    // Bandwidth Card
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

                // Recent Activity Section
                // Recent Activity Section
                GroupBox {
                    title: "🚨 Recent Blocked Activity"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font.bold: true
                    font.pixelSize: 16

                    ListView {
                        id: recentActivityList
                        anchors.fill: parent
                        model: networkSniffer.blockedPackets
                        clip: true
                        spacing: 5

                        delegate: Rectangle {
                            width: parent.width
                            height: 50
                            color: index % 2 === 0 ? "#f9f9f9" : "white"
                            radius: 5

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    packetDetailsWindow1.showDetails1(modelData);
                                }
                            }

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
                                        text: modelData.source + " → " + modelData.destination
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: "#2c3e50"
                                    }

                                    Text {
                                        text: "Protocol: " + modelData.protocol + " | Blocked by firewall rule"
                                        font.pixelSize: 12
                                        color: "#7f8c8d"
                                    }
                                }
                            }
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AlwaysOn
                        }
                    }
                }

                // Window to display packet details
                Window {
                    id: packetDetailsWindow1
                    width: 600
                    height: 400
                    title: "Blocked Packet Details"
                    visible: false

                    function showDetails1(packet) {
                        detailsText1.text = `
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
                            <b>Failed Attempts:</b> ${packet.failedAttempts}<br>
                            <b>Transaction Hour:</b> ${packet.transactionHour}<br>
                            <b>Is Weekend:</b> ${packet.isWeekend}<br>
                        `
                        visible = true
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Text {
                                id: detailsText1
                                font.pixelSize: 14
                                wrapMode: Text.Wrap
                                textFormat: Text.RichText
                            }
                        }

                        Button {
                            text: "Close"
                            onClicked: packetDetailsWindow1.visible = false
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }

                // Firewall Rules Quick Stats
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    GroupBox {
                        title: "🔒 Active Firewall Rules"
                        Layout.fillWidth: true
                        font.bold: true

                        ColumnLayout {
                            spacing: 8

                            Text {
                                text: "Total Rules: " + networkSniffer.firewallRulesCount
                                font.pixelSize: 14
                            }

                            Repeater {
                                model: networkSniffer.firewallRules
                                delegate: Text {
                                    text: "• " + modelData.sourceIp + ":" + modelData.port +
                                          " (" + modelData.protocol + ") - " + modelData.action
                                    font.pixelSize: 12
                                    color: modelData.action === "Block" ? "#e74c3c" : "#2ecc71"
                                }
                            }
                        }
                    }

                    GroupBox {
                        title: "📈 Traffic Composition"
                        Layout.fillWidth: true
                        font.bold: true
                    }
                }

                // Back Button
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
                    onClicked: {
                        dashboardPage.visible = false;
                        firewallRulesetPage.visible = false;
                    }
                }
            }
        }


        // Firewall Ruleset Page
        Rectangle {
            id: firewallRulesetPage
            anchors.top: navbardiv.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: false
            color: "#FFFFFF"
            z: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 15
                anchors.margins: 20

                // Header
                Text {
                    text: "Firewall Rule Management"
                    font.family: "Arial"
                    font.bold: true
                    font.pointSize: 24
                    color: "#2c3e50"
                    Layout.alignment: Qt.AlignHCenter
                }

                // Add New Rule Section
                GroupBox {
                    title: "➕ Add New Rule"
                    Layout.fillWidth: true
                    font.bold: true
                    font.pixelSize: 16


                    GridLayout {
                        columns: 2
                        width: parent.width
                        rowSpacing: 15
                        columnSpacing: 20

                        // IP Address Input
                                   Text {
                                       text: "IP Address:"
                                       font.pixelSize: 12
                                       color: "#000000"
                                       Layout.columnSpan: 2
                                   }

                                   TextField {
                                       id: ruleIpInput
                                       placeholderText: "Leave empty for any IP"
                                       Layout.columnSpan: 2
                                       Layout.fillWidth: true
                                       background: Rectangle {
                                           radius: 4
                                           border.color: "#dee2e6"
                                           color: "#000000"
                                       }
                                   }

                                   // Port Input
                                   Text {
                                       text: "Port:"
                                       font.pixelSize: 12
                                       color: "#000000"
                                   }

                                   TextField {
                                       id: rulePortInput
                                       placeholderText: "0 for any port"
                                       validator: IntValidator { bottom: 0; top: 65535 }
                                       Layout.fillWidth: true
                                       background: Rectangle {
                                           radius: 4
                                           border.color: "#dee2e6"
                                           color: "#000000"
                                       }
                                   }

                                   // Protocol Selection
                                   Text {
                                       text: "Protocol:"
                                       font.pixelSize: 12
                                        color: "#000000"
                                   }

                                   ComboBox {
                                       id: ruleProtocolSelect
                                       model: ["Any", "TCP", "UDP"]
                                       Layout.fillWidth: true
                                       background: Rectangle {
                                           radius: 4
                                           border.color: "#dee2e6"
                                            color: "#000000"
                                       }
                                   }

                                   // Action Selection
                                   Text {
                                       text: "Action:"
                                       font.pixelSize: 12
                                       color: "#7f8c8d"
                                   }

                                   ComboBox {
                                       id: ruleActionSelect
                                       model: ["Block", "Allow"]
                                       Layout.fillWidth: true
                                       background: Rectangle {
                                           radius: 4
                                           border.color: "#dee2e6"
                                           color: "#000000"
                                       }
                                   }

                                   // Add Rule Button
                                   Button {
                                       text: "Add Rule"
                                       Layout.columnSpan: 2
                                       Layout.fillWidth: true
                                       background: Rectangle {
                                           // color: "#3498db"
                                           color: "#000000"
                                           radius: 8
                                       }
                                       contentItem: Text {
                                           text: parent.text
                                           color: "white"
                                           horizontalAlignment: Text.AlignHCenter
                                           font.bold: true
                                       }
                                       onClicked: {
                                           networkSniffer.addFirewallRule(
                                               ruleIpInput.text,
                                               parseInt(rulePortInput.text || 0),
                                               ruleProtocolSelect.currentText,
                                               ruleActionSelect.currentText
                                           )
                                           ruleIpInput.clear()
                                           rulePortInput.clear()
                                       }
                                   }
                               }


                           }

                // Active Rules Section
                GroupBox {
                    title: "📜 Active Rules"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font.bold: true
                    font.pixelSize: 16

                    ListView {
                        id: activeRulesList
                        anchors.fill: parent
                        model: networkSniffer.firewallRules
                        spacing: 8
                        clip: true

                        delegate: Rectangle {
                            width: parent.width
                            height: 60
                            radius: 8
                            // color: "#f8f9fa"
                             color: "#000000"
                            border.color: "#e9ecef"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 15

                                // Status Indicator
                                Rectangle {
                                    width: 5
                                    height: parent.height
                                    color: model.action === "Block" ? "#e74c3c" : "#2ecc71"
                                    radius: 2
                                }

                                // Rule Details
                                ColumnLayout {
                                    spacing: 4
                                    Layout.fillWidth: true

                                    Text {
                                        text: (model.sourceIp || "Any IP") + ":" + (model.port || "Any")
                                        font.bold: true
                                        font.pixelSize: 14
                                        color: "#2c3e50"
                                         // color: "#000000"
                                    }

                                    Text {
                                        text: model.protocol + " • " + model.action
                                        font.pixelSize: 12
                                        // color: "#7f8c8d"
                                         color: "#000000"
                                    }
                                }

                                // Remove Button
                                ToolButton {
                                    // iconSource: "qrc:/icons/trash.svg"
                                    text: "🗑️"  // Trash can emoji
                                    onClicked: networkSniffer.removeFirewallRule(index)
                                }
                            }
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AlwaysOn
                            width: 8
                        }
                    }
                }

                // Back Button
                Button {
                    text: "⬅ Back to Dashboard"
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
                    onClicked: {
                        dashboardPage.visible = true
                        firewallRulesetPage.visible = false
                    }
                }
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
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                    }

                    Text {
                        text: qsTr("Dashboard")
                        font.family: "Arial"
                        font.pointSize: 10.5
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                dashboardPage.visible = true;
                                firewallRulesetPage.visible = false;
                            }
                        }
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
                        MouseArea {
                               anchors.fill: parent
                               onClicked: {
                                   firewallRulesetPage.visible = true;
                                   dashboardPage.visible = false;
                               }
                           }
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


                ListView {
                    id: packetListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true // Ensure content is clipped within the ListView
                    spacing: 1 // Add spacing between rows

                    // Header Row
                    header: Rectangle {
                        width: packetListView.width
                        height: 40
                        color: "#4A90E2" // Header background color
                        Row {
                            spacing: 1
                            Repeater {
                                model: ["Time", "Source", "Destination", "Protocol", "Source Port", "Destination Port", "Payload Length", "Flags", "Window Size", "Geolocation"]
                                delegate: Rectangle {
                                    width: 120
                                    height: 40
                                    color: "transparent" // Transparent background for header cells

                                    Text {
                                        text: modelData
                                        anchors.centerIn: parent
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: "#FFFFFF" // White text for header
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }

                    // Packet Rows
                    model: ListModel {
                        id: packetModel
                    }
                    delegate: Rectangle {
                        width: packetListView.width
                        height: 40
                        color: index % 2 === 0 ? "#F5F5F5" : "#E0E0E0" // Alternating row colors
                        border.color: "#D0D0D0"

                        Row {
                            spacing: 1
                            Repeater {
                                model: [time, source, destination, protocol, sourcePort, destinationPort, payloadLength, flags, windowSize, geolocation]
                                delegate: Rectangle {
                                    width: 120
                                    height: 40

                                    Text {
                                        text: modelData
                                        anchors.centerIn: parent
                                        font.pixelSize: 12
                                        color: "#333333" // Dark text for better readability
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }

                        // Hover Effect
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "#D0E0F0" // Highlight row on hover
                            onExited: parent.color = index % 2 === 0 ? "#F5F5F5" : "#E0E0E0" // Restore original color
                            onClicked: {
                                // Open detailed packet view
                                packetDetailsWindow.visible = true;
                                packetDetailsWindow.loadPacketDetails(model);
                            }
                        }
                    }

                    // Scrollbar
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AlwaysOn // Ensure scrollbar is always visible
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
                    <b>Failed Attempts:</b> ${packet.failedAttempts}<br>
                    <b>Transaction Hour:</b> ${packet.transactionHour}<br>
                    <b>Is Weekend:</b> ${packet.isWeekend}<br>
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
