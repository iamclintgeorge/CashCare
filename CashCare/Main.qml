import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Fusion

ApplicationWindow {
    id: root
    width: 1020
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
                        onClicked: {
                            // Open the website login page
                            Qt.openUrlExternally("https://localhost:3000/login");
                        }
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
                        Layout.preferredHeight:18
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
    }
}
