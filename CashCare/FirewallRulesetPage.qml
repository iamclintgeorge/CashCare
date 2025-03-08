import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: firewallRulesetPage
    visible: false
    color: "#FFFFFF"

    // Feedback popup
    Rectangle {
        id: feedbackPopup
        width: 300
        height: 50
        color: "#2ecc71"
        radius: 8
        anchors.centerIn: parent
        visible: false
        z: 10

        Text {
            id: feedbackText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 16
        }

        Timer {
            id: feedbackTimer
            interval: 2000
            onTriggered: feedbackPopup.visible = false
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
                        model: ["TCP", "UDP", "ICMP", "HTTP", "HTTPS", "FTP", "SMTP"]
                        Layout.fillWidth: true
                        height: 40
                    }

                    Label { text: "Action:" }
                    ComboBox {
                        id: actionCombo
                        model: ["Allow", "Block"]
                        Layout.fillWidth: true
                        height: 40
                    }

                    Button {
                        text: "Add Rule"
                        Layout.columnSpan: 2
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            if (sourceIpField.text === "" || portField.text === "") {
                                feedbackText.text = "Error: IP and Port required";
                                feedbackPopup.color = "#e74c3c";
                                feedbackPopup.visible = true;
                                feedbackTimer.start();
                                console.log("Error: Source IP and Port must not be empty");
                                return;
                            }
                            var rule = {
                                sourceIp: sourceIpField.text,
                                port: portField.text,
                                protocol: protocolCombo.currentText,
                                action: actionCombo.currentText
                            };
                            console.log("Attempting to add rule:", JSON.stringify(rule));
                            var newRules = root.firewallRules.slice();
                            newRules.push(rule);
                            root.firewallRules = newRules;
                            if (typeof logPage !== "undefined" && logPage.addLogEntry) {
                                logPage.addLogEntry("Added rule: " + JSON.stringify(rule));
                            } else {
                                console.log("Warning: logPage.addLogEntry not available");
                            }
                            feedbackText.text = "Rule added successfully";
                            feedbackPopup.color = "#2ecc71";
                            feedbackPopup.visible = true;
                            feedbackTimer.start();
                            sourceIpField.text = "";
                            portField.text = "";
                            console.log("Current firewallRules after add:", JSON.stringify(root.firewallRules));
                        }
                    }
                }
            }

            GroupBox {
                title: "🔒 Active Rules (" + root.firewallRules.length + ")"
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    spacing: 8
                    width: parent.width

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Total Rules: " + root.firewallRules.length
                            font.pixelSize: 14
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "Clear All Rules"
                            visible: root.firewallRules.length > 0
                            background: Rectangle {
                                color: "#e74c3c"
                                radius: 5
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                            }
                            onClicked: {
                                console.log("Clearing all rules, previous state:", JSON.stringify(root.firewallRules));
                                if (typeof logPage !== "undefined" && logPage.addLogEntry) {
                                    logPage.addLogEntry("Cleared all firewall rules");
                                } else {
                                    console.log("Warning: logPage.addLogEntry not available");
                                }
                                root.firewallRules = [];
                                feedbackText.text = "All rules cleared";
                                feedbackPopup.color = "#e74c3c";
                                feedbackPopup.visible = true;
                                feedbackTimer.start();
                                console.log("Current firewallRules after clear:", JSON.stringify(root.firewallRules));
                            }
                        }
                    }

                    ScrollView {
                        width: parent.width
                        height: 300
                        clip: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 5

                            Repeater {
                                model: root.firewallRules
                                delegate: Rectangle {
                                    width: parent.width
                                    height: 60
                                    color: index % 2 === 0 ? "#f9f9f9" : "white"
                                    radius: 5

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 10

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 3

                                            Text {
                                                text: modelData.sourceIp + " → Port: " + modelData.port
                                                font.pixelSize: 14
                                                font.bold: true
                                                color: "#2c3e50"
                                            }

                                            Text {
                                                text: "Protocol: " + modelData.protocol + " | Action: " + modelData.action
                                                font.pixelSize: 12
                                                color: modelData.action === "Block" ? "#e74c3c" : "#2ecc71"
                                            }
                                        }

                                        Button {
                                            text: "Delete"
                                            background: Rectangle {
                                                color: "#e74c3c"
                                                radius: 5
                                            }
                                            contentItem: Text {
                                                text: parent.text
                                                color: "white"
                                                font.pixelSize: 12
                                                horizontalAlignment: Text.AlignHCenter
                                            }
                                            onClicked: {
                                                console.log("Deleting rule at index", index, ":", JSON.stringify(modelData));
                                                if (typeof logPage !== "undefined" && logPage.addLogEntry) {
                                                    logPage.addLogEntry("Deleted rule: " + JSON.stringify(modelData));
                                                } else {
                                                    console.log("Warning: logPage.addLogEntry not available");
                                                }
                                                var newRules = root.firewallRules.slice();
                                                newRules.splice(index, 1);
                                                root.firewallRules = newRules;
                                                feedbackText.text = "Rule deleted successfully";
                                                feedbackPopup.color = "#e74c3c";
                                                feedbackPopup.visible = true;
                                                feedbackTimer.start();
                                                console.log("Current firewallRules after delete:", JSON.stringify(root.firewallRules));
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn }
                    }
                }
            }
        }

        Button {
            text: "⬅ Back to Main"
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle { color: "#7f8c8d"; radius: 8 }
            contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter }
            onClicked: pageStack.clear()
        }
    }

    onVisibleChanged: {
        if (visible) {
            console.log("FirewallRulesetPage visible, current firewallRules:", JSON.stringify(root.firewallRules));
        }
    }
}
