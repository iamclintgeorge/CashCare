import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: navbardiv
    height: 50
    color: "#F9F9F9"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20

        RowLayout {
            spacing: 20

            Text {
                id: file
                text: qsTr("File")
                font.family: "Inter"
                font.pointSize: 10
                color: "#000000"

                MouseArea {
                    anchors.fill: parent
                    onClicked: fileMenu.visible = !fileMenu.visible
                }
            }

            Text { text: qsTr("Edit"); font.family: "Arial"; font.pointSize: 10; color: "#000000" }
            Text { text: qsTr("View"); font.family: "Arial"; font.pointSize: 10; color: "#000000" }
            Text { text: qsTr("Help"); font.family: "Arial"; font.pointSize: 10; color: "#000000" }
        }

        Item { Layout.fillWidth: true }

        TextField {
            id: searchBar
            Layout.fillWidth: true
            placeholderText: qsTr("Search...")
            font.family: "Arial"
            font.pointSize: 10
            leftPadding: 30
            background: Rectangle {
                color: "#FFFFFF"
                radius: 15
                Image {
                    source: "images/search.png"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    width: 16
                    height: 16
                }
            }
        }

        RowLayout {
            spacing: 10

            Button {
                icon.source: "images/settings.png"
                icon.width: 24
                icon.height: 24
                flat: true
                onClicked: console.log("Settings clicked")
            }

            Button {
                icon.source: "images/notification.png"
                icon.width: 24
                icon.height: 24
                flat: true
                onClicked: console.log("Notifications clicked")
            }

            Button {
                icon.source: "images/profile.png"
                icon.width: 24
                icon.height: 24
                flat: true
                onClicked: Qt.openUrlExternally("https://localhost:3000/login")
            }
        }
    }

    Rectangle {
        id: fileMenu
        width: 150
        height: 30
        visible: false
        color: "#FFFFFF"
        border.color: "#E6E6E6"
        anchors.top: file.bottom
        anchors.left: file.left
        anchors.topMargin: 5
        z: 100

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Rectangle {
            anchors.fill: parent
            color: fileMenuExitArea.containsMouse ? "#E6E6E6" : "#FFFFFF"

            Text {
                anchors.centerIn: parent
                text: "Exit"
                font.family: "Arial"
                font.pointSize: 10
                color: "#000000"
            }

            MouseArea {
                id: fileMenuExitArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Qt.quit()
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#E6E6E6"
    }
}
