// Sidebar.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebardiv
    width: 250
    color: "#F9F9F9"

    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 35

        RowLayout {
            Layout.leftMargin: 50
            Layout.topMargin: 35
            spacing: 10

            Image {
                source: "images/dashboard.png"
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
                        dashboardPage.visible = true
                        firewallRulesetPage.visible = false
                        networkSnifferPage.visible = false
                    }
                }
            }
        }

        RowLayout {
            Layout.leftMargin: 50
            spacing: 10

            Image {
                source: "images/firewall.png"
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
                        firewallRulesetPage.visible = true
                        dashboardPage.visible = false
                        networkSnifferPage.visible = false
                    }
                }
            }
        }

        RowLayout {
            Layout.leftMargin: 50
            spacing: 10

            Image {
                source: "images/network.png"
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
                        networkSnifferPage.visible = true
                        dashboardPage.visible = false
                        firewallRulesetPage.visible = false
                    }
                }
            }
        }

        RowLayout {
            Layout.leftMargin: 50
            spacing: 10

            Image {
                source: "images/log.png"
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
