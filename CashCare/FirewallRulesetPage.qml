import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.example 1.0

Rectangle {
    id: firewallRulesetPage
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
            text: "Firewall Rule Management"
            font.family: "Arial"
            font.bold: true
            font.pointSize: 24
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

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

                Text { text: "IP Address:"; font.pixelSize: 12; color: "#000000"; Layout.columnSpan: 2 }
                TextField {
                    id: ruleIpInput
                    placeholderText: "Leave empty for any IP"
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    background: Rectangle { radius: 4; border.color: "#dee2e6"; color: "#FFFFFF" }
                }

                Text { text: "Port:"; font.pixelSize: 12; color: "#000000" }
                TextField {
                    id: rulePortInput
                    placeholderText: "0 for any port"
                    validator: IntValidator { bottom: 0; top: 65535 }
                    Layout.fillWidth: true
                    background: Rectangle { radius: 4; border.color: "#dee2e6"; color: "#FFFFFF" }
                }

                Text { text: "Protocol:"; font.pixelSize: 12; color: "#000000" }
                ComboBox {
                    id: ruleProtocolSelect
                    model: ["Any", "TCP", "UDP"]
                    Layout.fillWidth: true
                    background: Rectangle { radius: 4; border.color: "#dee2e6"; color: "#FFFFFF" }
                }

                Text { text: "Action:"; font.pixelSize: 12; color: "#000000" }
                ComboBox {
                    id: ruleActionSelect
                    model: ["Block", "Allow"]
                    Layout.fillWidth: true
                    background: Rectangle { radius: 4; border.color: "#dee2e6"; color: "#FFFFFF" }
                }

                Button {
                    text: "Add Rule"
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    background: Rectangle { color: "#3498db"; radius: 8 }
                    contentItem: Text { text: parent.text; color: "white"; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                    onClicked: {
                        var rule = {
                            sourceIp: ruleIpInput.text || "Any",
                            port: parseInt(rulePortInput.text) || 0,
                            protocol: ruleProtocolSelect.currentText,
                            action: ruleActionSelect.currentText
                        }
                        root.firewallRules.push(rule)
                        ruleIpInput.clear()
                        rulePortInput.clear()
                    }
                }
            }
        }

        GroupBox {
            title: "📜 Active Rules"
            Layout.fillWidth: true
            Layout.fillHeight: true
            font.bold: true
            font.pixelSize: 16

            ListView {
                id: activeRulesList
                anchors.fill: parent
                model: root.firewallRules
                spacing: 8
                clip: true

                delegate: Rectangle {
                    width: parent.width
                    height: 60
                    radius: 8
                    color: "#FFFFFF"
                    border.color: "#e9ecef"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 15

                        Rectangle {
                            width: 5
                            height: parent.height
                            color: modelData.action === "Block" ? "#e74c3c" : "#2ecc71"
                            radius: 2
                        }

                        ColumnLayout {
                            spacing: 4
                            Layout.fillWidth: true

                            Text {
                                text: (modelData.sourceIp || "Any IP") + ":" + (modelData.port || "Any")
                                font.bold: true
                                font.pixelSize: 14
                                color: "#2c3e50"
                            }

                            Text {
                                text: modelData.protocol + " • " + modelData.action
                                font.pixelSize: 12
                                color: "#7f8c8d"
                            }
                        }

                        ToolButton {
                            text: "🗑️"
                            onClicked: {
                                root.firewallRules.splice(index, 1)
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    width: 8
                }
            }
        }

        Button {
            text: "⬅ Back to Dashboard"
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle { color: "#7f8c8d"; radius: 8 }
            contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter }
            onClicked: pageStack.replace(dashboardPage)
        }
    }
}
