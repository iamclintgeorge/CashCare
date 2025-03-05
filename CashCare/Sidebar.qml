import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebardiv
    width: 250
    color: "#F9F9F9"

    signal pageSelected(string page)

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
                    onClicked: sidebardiv.pageSelected("dashboard")
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
                    onClicked: sidebardiv.pageSelected("firewall")
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
                    onClicked: sidebardiv.pageSelected("sniffer")
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
                // No action implemented yet
            }
        }
    }
}
