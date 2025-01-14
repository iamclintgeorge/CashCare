import QtQuick
import QtQuick.Layouts
import QtQuick.Window 2.0
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 1020
    height: 720
    visible: true
    title: qsTr("CashCare - Securing Transactions, one at a time")
    color: "#EAEAEA"
        Rectangle {
            id: navbardiv
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.fillWidth: true
            implicitHeight: 50
            color: "#F9F9F9"
            Rectangle {
                color: "#F9F9F9"
                anchors.fill: parent
                anchors.margins: 20

            RowLayout{
                anchors.fill: parent
                Layout.topMargin: 50
                Layout.fillWidth: true
                RowLayout {
                    id: leftnavbar
                    Layout.fillWidth: true
                    Text {
                        id: file
                        text: qsTr("File")
                        font.family: "Inter"
                        font.pointSize: 10
                        Layout.leftMargin: 1
                        MouseArea {
                            anchors.fill: parent
                            onClicked: menu.visible = !menu.visible
                        }
                    }
                    Text {
                        id: edit
                        text: qsTr("Edit")
                        font.family: "Arial"
                        font.pointSize: 10
                        Layout.leftMargin: 11
                    }
                    Text {
                        id: view
                        text: qsTr("View")
                        font.family: "Arial"
                        font.pointSize: 10
                        Layout.leftMargin: 11
                    }
                    Text {
                        id: help
                        text: qsTr("Help")
                        font.family: "Arial"
                        font.pointSize: 10
                        Layout.leftMargin: 11
                    }
                }
                Item {
                    id: centernavbar
                    Layout.fillWidth: true
                }
                RowLayout {
                    id: rightnavbar
                    Layout.alignment: Qt.AlignRight
                    Text{
                        text: qsTr("Settings")
                        font.family: "Arial"
                        font.pointSize: 10
                        Layout.rightMargin: 10
                    }
                    Text{
                        text: qsTr("Notification")
                        font.family: "Arial"
                        font.pointSize: 10
                        Layout.rightMargin: 10
                    }
                    Text{
                        text: qsTr("Login")
                        font.family: "Arial"
                        font.pointSize: 10
                        Layout.rightMargin: 10
                    }
                    }
            }
            Rectangle {
                       id: menu
                       width: 150
                       height: 100
                       color: "red"
                       visible: false
                       anchors.top: file.bottom
                       anchors.left: file.left
                       anchors.topMargin: 5
                       anchors.leftMargin: 0

                       ColumnLayout {
                           spacing: 10

                           Rectangle {
                               implicitWidth: parent.width
                               implicitHeight: 30
                               color: "#F9F9F9"
                               border.color: "#E6E6E6"
                               Text {
                                   anchors.centerIn: parent
                                   text: "Exit"
                                   color: "black"
                                   MouseArea {
                                       anchors.fill: parent
                                       onClicked: Qt.quit()
                                   }
                               }
                           }
                       }
                   }
            }
            Rectangle{
                id: navbarborder
                anchors.bottom: navbardiv.bottom
                anchors.left: navbardiv.left
                anchors.right: navbardiv.right
                height: 1
                color: "#E6E6E6"
            }
    }
        Rectangle{
            id: sidebardiv
            anchors.top: navbardiv.bottom
            anchors.bottom: statusbardiv.top
            anchors.left: parent.left
            color: "#F9F9F9"
            implicitWidth: 250
            ColumnLayout{
                Text {
                    id: dashboard
                    text: qsTr("Dashboard")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }
                Text {
                    id: ruleset
                    text: qsTr("Firewall ruleset")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }
                Text {
                    id: networks
                    text: qsTr("Check networks")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }
                Text {
                    id: logs
                    text: qsTr("Log history")
                    font.family: "Arial"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }
            }
        }
        Rectangle{
            id: statusbardiv
            color: "#F9F9F9"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 25
            MouseArea{
                anchors.fill: parent
            onClicked:{
                console.log("Button was clicked")
            }
            }
            Rectangle{
            anchors.fill: parent
            RowLayout{
            anchors.fill: parent
            RowLayout{
                Layout.leftMargin: 20
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
                Layout.leftMargin: 10
            }
            }
            RowLayout{
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 20
                Text {
                    text: qsTr("Help")
                    font.family: "Arial"
                    font.pointSize: 8
                    color: "#757575"
                }
            }
            }
            }
            Rectangle{
                id: statusbarborder
                anchors.top: statusbardiv.top
                anchors.left: statusbardiv.left
                anchors.right: statusbardiv.right
                height: 1
                color: "#E6E6E6"
            }
        }
}
