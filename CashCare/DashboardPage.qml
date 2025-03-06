import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.example 1.0

Rectangle {
    id: dashboardPage
    visible: false
    color: "#FFFFFF"

    NetworkSniffer {
        id: networkSniffer
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        Text {
            text: "Network Security Dashboard"
            font.family: "Arial"
            font.bold: true
            font.pointSize: 24
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

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
                        text: networkSniffer.totalPackets // Use C++ property directly
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                    }
                }
            }

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
                        text: root.blockedPackets
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                    }
                }
            }

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
                        text: root.bandwidthUsage.toFixed(2) + " KB/s"
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }

        GroupBox {
            title: "🚨 Recent Blocked Activity"
            Layout.fillWidth: true
            Layout.fillHeight: true
            font.bold: true
            font.pixelSize: 16

            ListView {
                id: recentActivityList
                anchors.fill: parent
                model: ListModel { id: blockedPacketsModel }
                clip: true
                spacing: 5

                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    color: index % 2 === 0 ? "#f9f9f9" : "white"
                    radius: 5

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
                                text: model.source + " → " + model.destination
                                font.pixelSize: 14
                                font.bold: true
                                color: "#2c3e50"
                            }

                            Text {
                                text: "Protocol: " + model.protocol + " | Blocked by firewall rule"
                                font.pixelSize: 12
                                color: "#7f8c8d"
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: packetDetailsWindow1.showDetails1(model)
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
            }
        }

        PacketDetailsWindow {
            id: packetDetailsWindow1
        }

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
                        text: "Total Rules: " + root.firewallRules.length
                        font.pixelSize: 14
                    }

                    Repeater {
                        model: root.firewallRules
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
            onClicked: pageStack.clear()
        }
    }
}
