import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

ApplicationWindow {
    id: root
    width: 1020
    height: 720
    visible: true
    title: qsTr("CashCare - Securing Transactions, one at a time")
    color: "#EAEAEA"

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

            Rectangle {
                anchors.fill: parent
                anchors.margins: 20
                color: "#F9F9F9"

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    // Left navbar items
                    RowLayout {
                        id: leftnavbar
                        spacing: 11

                        Text {
                            id: file
                            text: qsTr("File")
                            font.family: "Inter"
                            font.pointSize: 10
                            MouseArea {
                                anchors.fill: parent
                                onClicked: menu.visible = !menu.visible
                            }
                        }

                        Text {
                            text: qsTr("Edit")
                            font.family: "Arial"
                            font.pointSize: 10
                        }

                        Text {
                            text: qsTr("View")
                            font.family: "Arial"
                            font.pointSize: 10
                        }

                        Text {
                            text: qsTr("Help")
                            font.family: "Arial"
                            font.pointSize: 10
                        }
                    }

                    // Center spacer
                    Item {
                        Layout.fillWidth: true
                    }

                    // Right navbar items
                    RowLayout {
                        spacing: 10

                        Text {
                            text: qsTr("Settings")
                            font.family: "Arial"
                            font.pointSize: 10
                        }

                        Text {
                            text: qsTr("Notification")
                            font.family: "Arial"
                            font.pointSize: 10
                        }

                        Button {
                            text: qsTr("Login")
                            font.family: "Arial"
                            font.pointSize: 10
                        }
                    }
                }

                // File menu popup
                Rectangle {
                    id: menu
                    width: 150
                    height: 100
                    visible: false
                    color: "#F9F9F9"
                    border.color: "#E6E6E6"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 30

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5

                        Rectangle {
                            Layout.fillWidth: true
                            height: 30
                            color: "#F9F9F9"
                            border.color: "#E6E6E6"

                            Text {
                                anchors.centerIn: parent
                                text: "Exit"
                                color: "black"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Qt.quit()
                            }
                        }
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

                Text {
                    text: qsTr("Dashboard")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }

                Text {
                    text: qsTr("Firewall ruleset")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                }

                Text {
                    text: qsTr("Check networks")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                }

                Text {
                    text: qsTr("Log history")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
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
                        text: qsTr("Connected to Internet")
                        font.family: "Arial"
                        font.pointSize: 8
                        color: "#757575"
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
