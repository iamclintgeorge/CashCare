// Statusbar.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: statusbardiv
    height: 25
    color: "#F9F9F9"

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#E6E6E6"
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5

        RowLayout {
            spacing: 10
            Layout.leftMargin: 15

            Text {
                text: qsTr("Layout")
                font.family: "Arial"
                font.pointSize: 8
                color: "#757575"
            }

            Text {
                text: root.isConnectedToInternet ? "Connected to Internet" : "Not Connected to Internet"
                font.family: "Arial"
                font.pointSize: 8
                color: root.isConnectedToInternet ? "#757575" : "#FF0000"
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: qsTr("Help")
            font.family: "Arial"
            font.pointSize: 8
            color: "#757575"
            Layout.rightMargin: 15
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: console.log("Status bar clicked")
    }
}
