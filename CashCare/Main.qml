import QtQuick
import QtQuick.Layouts
import QtQuick.Window 2.0
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("CashCare - Securing Transactions, one at a time")
    color: "#EAEAEA"
    // menuBar: MenuBar {
    //     background: Rectangle {
    //         color: "#F9F9F9"
    //     }
    //         Menu {
    //             title: qsTr("File")
    //             MenuItem {
    //                 contentItem: Text {
    //                     text: "Exit"
    //                     color: "red"  // Set text color
    //                 }
    //                 onTriggered: Qt.quit();
    //                 background: Rectangle {
    //                     color: "#F9F9F9"
    //                 }

    //             }
    //             MenuItem {
    //                 text: "File - Item 2"
    //                 onTriggered: statusLabel.text = "File - Item 2 Triggered"
    //             }
    //         }
    // }
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
                Layout.topMargin: 50
                RowLayout {
                    id: leftnavbar
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
                        font.family: "Inter"
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
                RowLayout {
                    id: rightnavbar
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
                    font.family: "Roboto"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }
                Text {
                    id: ruleset
                    text: qsTr("Firewall ruleset")
                    font.family: "Roboto"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }
                Text {
                    id: networks
                    text: qsTr("Check networks")
                    font.family: "Roboto"
                    font.pointSize: 10.5
                    Layout.leftMargin: 50
                    Layout.topMargin: 35
                }
                Text {
                    id: logs
                    text: qsTr("Log history")
                    font.family: "Roboto"
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
            height: 20
            MouseArea{
                anchors.fill: parent
            onClicked:{
                console.log("Button was clicked")
            }
            }
        }
}
