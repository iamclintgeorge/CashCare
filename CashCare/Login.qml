import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Page {
    Rectangle {
        id: root
        color: "#EAEAEA"
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent
            Rectangle{
                Layout.preferredWidth: parent.width / 2
                Text {
                    id: txt
                    text: qsTr("Hello Login")
                    anchors.centerIn: parent
                }
                Button{
                    text: ("Home Page")
                    anchors.top: txt.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: changer.push("Main.qml")

                }
                StackView{
                    id: changer
                    anchors.fill: parent
                }
            }
            Rectangle{
                Layout.preferredWidth: parent.width / 2
                Text {
                    id: emailtxt
                    text: qsTr("Email ID")
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
                TextField {
                    anchors.top: emailtxt.bottom
                    id: emailid
                    placeholderText: "Enter Email"
                    anchors.left: emailtxt.left
                    anchors.right: parent.right
                    anchors.margins: 10
                }
                Text {
                    id: passwordtxt
                    text: qsTr("Password")
                    anchors.top: emailid.bottom
                    anchors.left: emailid.left
                }
                TextField {
                    anchors.top: passwordtxt.bottom
                    id: passwrd
                    placeholderText: "Enter Password"
                    anchors.left: emailtxt.left
                    anchors.right: emailid.right
                    anchors.margins: 10
                }

            }

        }
    }
}
