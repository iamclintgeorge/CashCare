import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: firewallRulesetPage
    visible: false
    color: "#FFFFFF"

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        Text {
            text: "Firewall Ruleset"
            font.family: "Arial"
            font.bold: true
            font.pointSize: 24
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            GroupBox {
                title: "➕ Add New Rule"
                Layout.fillWidth: true

                GridLayout {
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 10

                    Label { text: "Source IP:" }
                    TextField {
                        id: sourceIpField
                        placeholderText: "e.g., 192.168.1.1"
                        Layout.fillWidth: true
                    }

                    Label { text: "Port:" }
                    TextField {
                        id: portField
                        placeholderText: "e.g., 80"
                        Layout.fillWidth: true
                    }

                    Label { text: "Protocol:" }
                    ComboBox {
                        id: protocolCombo
                        model: ["TCP", "UDP", "ICMP", "HTTP", "HTTPS", "FTP", "SMTP"]
                        Layout.fillWidth: true
                        height: 40 // Increased height
                    }

                    Label { text: "Action:" }
                    ComboBox {
                        id: actionCombo
                        model: ["Allow", "Block"]
                        Layout.fillWidth: true
                        height: 40 // Increased height
                    }

                    Button {
                        text: "Add Rule"
                        Layout.columnSpan: 2
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            var rule = {
                                sourceIp: sourceIpField.text,
                                port: portField.text,
                                protocol: protocolCombo.currentText,
                                action: actionCombo.currentText
                            };
                            root.firewallRules.push(rule);
                            root.firewallRulesChanged(); // Notify Main.qml
                            console.log("Added rule:", JSON.stringify(rule));
                            sourceIpField.text = "";
                            portField.text = "";
                        }
                    }
                }
            }

            GroupBox {
                title: "🔒 Active Rules"
                Layout.fillWidth: true

                ScrollView {
                    width: parent.width
                    height: 200

                    ListView {
                        model: root.firewallRules
                        delegate: Text {
                            text: modelData.sourceIp + ":" + modelData.port +
                                  " (" + modelData.protocol + ") - " + modelData.action
                            font.pixelSize: 14
                            color: modelData.action === "Block" ? "#e74c3c" : "#2ecc71"
                            padding: 5
                        }
                    }
                }
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
            }
            onClicked: pageStack.clear()
        }
    }
}
