import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import CashCare 1.0

ApplicationWindow {
    id: root
    width: 1200
    height: 720
    visible: true
    title: qsTr("CashCare - Securing Transactions, one at a time")
    color: "#EAEAEA"

    property bool isConnectedToInternet: false
    property var whitelist: []
    property var blacklist: []
    property var firewallRules: [] // Implicitly provides firewallRulesChanged signal
    property int totalPackets: 0
    property int blockedPackets: 0
    property real bandwidthUsage: 0.0

    function checkInternetConnection() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://www.google.com", true)
        xhr.timeout = 3000

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.isConnectedToInternet = xhr.status === 200
            }
        }

        xhr.ontimeout = function() {
            root.isConnectedToInternet = false
        }

        xhr.send()
    }

    Timer {
        id: internetCheckTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.checkInternetConnection()
    }

    function isIpAllowed(ip) {
        if (root.whitelist.length > 0) {
            return root.whitelist.includes(ip)
        } else if (root.blacklist.length > 0) {
            return !root.blacklist.includes(ip)
        }
        return true
    }

    function addToWhitelist(ip) {
        if (!root.whitelist.includes(ip)) {
            root.whitelist.push(ip)
        }
    }

    function addToBlacklist(ip) {
        if (!root.blacklist.includes(ip)) {
            root.blacklist.push(ip)
        }
    }

    function removeFromWhitelist(ip) {
        root.whitelist = root.whitelist.filter(item => item !== ip)
    }

    function removeFromBlacklist(ip) {
        root.blacklist = root.blacklist.filter(item => item !== ip)
    }

    Rectangle {
        id: mainContent
        anchors.fill: parent
        color: "#EAEAEA"

        Navbar {
            id: navbar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Sidebar {
            id: sidebar
            anchors.top: navbar.bottom
            anchors.bottom: statusbar.top
            anchors.left: parent.left
        }

        Statusbar {
            id: statusbar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }

        StackView {
            id: pageStack
            anchors.top: navbar.bottom
            anchors.bottom: statusbar.top
            anchors.left: sidebar.right
            anchors.right: parent.right
            initialItem: dashboardPage
        }

        DashboardPage { id: dashboardPage; visible: false }
        FirewallRulesetPage { id: firewallRulesetPage; visible: false }
        NetworkSnifferPage { id: networkSnifferPage; visible: false }
        LogPage { id: logPage; visible: false } // Added LogPage as per your recent request

        Connections {
            target: sidebar
            function onPageSelected(page) {
                if (page === "dashboard") pageStack.replace(dashboardPage)
                else if (page === "firewall") pageStack.replace(firewallRulesetPage)
                else if (page === "sniffer") pageStack.replace(networkSnifferPage)
                else if (page === "log") pageStack.replace(logPage) // Added log page navigation
            }
        }
    }
}
