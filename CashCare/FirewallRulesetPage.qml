import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: firewallRulesetPage
    visible: false
    color: "#FFFFFF"

    // Simple feedback text
    Text {
        id: feedbackText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        color: "#2ecc71"
        font.pixelSize: 16
        visible: false
        z: 10

        Timer {
            id: feedbackTimer
            interval: 2000
            onTriggered: feedbackText.visible = false
        }
    }

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
                        model: ["TCP", "UDP", "ICMP", "HTTP", "HTTPS", "FTP", "SMTP", "DNS", "SSH", "Telnet"]
                        Layout.fillWidth: true
                    }

                    Label { text: "Action:" }
                    ComboBox {
                        id: actionCombo
                        model: ["Allow", "Block"]
                        Layout.fillWidth: true
                    }

                    Button {
                        text: "Add Rule"
                        Layout.columnSpan: 2
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            if (sourceIpField.text === "" || portField.text === "") {
                                feedbackText.text = "Error: IP and Port required";
                                feedbackText.color = "#e74c3c";
                                feedbackText.visible = true;
                                feedbackTimer.start();
                                return;
                            }

                            var rule = {
                                sourceIp: sourceIpField.text,
                                port: portField.text,
                                protocol: protocolCombo.currentText,
                                action: actionCombo.currentText
                            };

                            var newRules = root.firewallRules.slice();
                            newRules.push(rule);
                            root.firewallRules = newRules;

                            feedbackText.text = "Rule added";
                            feedbackText.color = "#2ecc71";
                            feedbackText.visible = true;
                            feedbackTimer.start();
                            console.log("Added rule:", JSON.stringify(rule));

                            // Log the action
                            if (typeof logPage !== "undefined" && logPage.addLogEntry) {
                                logPage.addLogEntry("Added rule: " + JSON.stringify(rule));
                            } else {
                                console.log("Warning: logPage.addLogEntry not available");
                            }

                            sourceIpField.text = "";
                            portField.text = "";
                        }
                    }
                }
            }

            GroupBox {
                title: "🔒 Active Rules (" + root.firewallRules.length + ")"
                Layout.fillWidth: true
                Layout.fillHeight: true

                ScrollView {
                    width: parent.width
                    height: 300
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 5

                        Repeater {
                            model: root.firewallRules
                            delegate: RowLayout {
                                width: parent.width
                                height: 40
                                spacing: 10

                                Text {
                                    text: modelData.sourceIp + ":" + modelData.port + " (" + modelData.protocol + ") - " + modelData.action
                                    font.pixelSize: 14
                                    color: modelData.action === "Block" ? "#e74c3c" : "#2ecc71"
                                    Layout.fillWidth: true
                                }

                                Button {
                                    text: "Delete"
                                    onClicked: {
                                        var newRules = root.firewallRules.slice();
                                        newRules.splice(index, 1);
                                        root.firewallRules = newRules;
                                        feedbackText.text = "Rule deleted";
                                        feedbackText.color = "#e74c3c";
                                        feedbackText.visible = true;
                                        feedbackTimer.start();
                                        console.log("Deleted rule at index", index);

                                        // Log the deletion
                                        if (typeof logPage !== "undefined" && logPage.addLogEntry) {
                                            logPage.addLogEntry("Deleted rule: " + JSON.stringify(modelData));
                                        } else {
                                            console.log("Warning: logPage.addLogEntry not available");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Button {
            text: "⬅ Back to Main"
            Layout.alignment: Qt.AlignHCenter
            onClicked: pageStack.clear()
        }
    }
}
