// PacketDetailsWindow.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: packetDetailsWindow
    width: 600
    height: 400
    title: "Packet Details"
    visible: false

    property var packetData: null

    function showDetails1(packet) {
        detailsText.text = `
            <b>Time:</b> ${packet.time}<br>
            <b>Source:</b> ${packet.source}<br>
            <b>Destination:</b> ${packet.destination}<br>
            <b>Protocol:</b> ${packet.protocol}<br>
            <b>Source Port:</b> ${packet.sourcePort}<br>
            <b>Destination Port:</b> ${packet.destinationPort}<br>
            <b>Payload Length:</b> ${packet.payloadLength}<br>
            <b>Flags:</b> ${packet.flags}<br>
            <b>Window Size:</b> ${packet.windowSize}<br>
            <b>Geolocation:</b> ${packet.geolocation}<br>
            <b>Failed Attempts:</b> ${packet.failedAttempts}<br>
            <b>Transaction Hour:</b> ${packet.transactionHour}<br>
            <b>Is Weekend:</b> ${packet.isWeekend}<br>
        `
        visible = true
    }

    function loadPacketDetails(packet) {
        packetData = packet
        detailsText.text = `
            <b>Time:</b> ${packet.time}<br>
            <b>Source:</b> ${packet.source}<br>
            <b>Destination:</b> ${packet.destination}<br>
            <b>Protocol:</b> ${packet.protocol}<br>
            <b>Source Port:</b> ${packet.sourcePort}<br>
            <b>Destination Port:</b> ${packet.destinationPort}<br>
            <b>Payload Length:</b> ${packet.payloadLength}<br>
            <b>Flags:</b> ${packet.flags}<br>
            <b>Window Size:</b> ${packet.windowSize}<br>
            <b>Geolocation:</b> ${packet.geolocation}<br>
            <b>Failed Attempts:</b> ${packet.failedAttempts}<br>
            <b>Transaction Hour:</b> ${packet.transactionHour}<br>
            <b>Is Weekend:</b> ${packet.isWeekend}<br>
        `
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                id: detailsText
                font.pixelSize: 14
                wrapMode: Text.Wrap
                textFormat: Text.RichText
            }
        }

        Button {
            text: "Close"
            onClicked: packetDetailsWindow.visible = false
            Layout.alignment: Qt.AlignRight
        }
    }
}
