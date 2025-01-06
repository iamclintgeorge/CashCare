import QtQuick
import QtQuick.Layouts

Window {
    id: root
    width: 640
    height: 480
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
                Layout.topMargin: 50
                RowLayout {
                    id: leftnavbar
                    Text {
                        id: file
                        text: qsTr("File")
                        font.family: "Inter"
                        font.pointSize: 10
                        Layout.leftMargin: 1
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
    }
        Rectangle{
            id: sidebardiv
            anchors.top: navbardiv.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: "#F9F9F9"
            implicitWidth: 200
        }
}
