// NetworkSnifferPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: networkSnifferPage
    visible: false
    color: "#FFFFFF"

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
                    Repeater {
                        model: ["Time", "Source", "Destination", "Protocol", "Source Port", "Destination Port", "Payload Length", "Flags", "Window Size", "Geolocation"]
                        delegate: Rectangle {
                            width: 120
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
                    Repeater {
                        model: [time, source, destination, protocol, sourcePort, destinationPort, payloadLength, flags, windowSize, geolocation]
                        delegate: Rectangle {
                            width: 120
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
        }

        Button {
            text: "Back"
            font.family: "Arial"
            font.pointSize: 12
            Layout.alignment: Qt.AlignHCenter
            onClicked: networkSnifferPage.visible = false
        }
    }

    PacketDetailsWindow {
        id: packetDetailsWindow
    }
}
