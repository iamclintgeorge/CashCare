#include "packetparser.h"
#include "networkutils.h"
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <QRegularExpression>

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
struct ether_header {
    u_char ether_dhost[6];
    u_char ether_shost[6];
    u_short ether_type;
};
#define ETHERTYPE_IP 0x0800
#else
#include <net/ethernet.h>
#endif

QString PacketParser::parsePacket(const struct pcap_pkthdr *header, const u_char *packetData) {
    if (header->caplen < sizeof(struct ether_header)) {
        return "Packet too short for Ethernet header";
    }

    struct ether_header *ethHeader = (struct ether_header *)packetData;
    QString packetDetails = QString("Ethernet Header:\n");
    packetDetails += QString("  Source MAC: %1\n").arg(NetworkUtils::macToString(ethHeader->ether_shost));
    packetDetails += QString("  Destination MAC: %1\n").arg(NetworkUtils::macToString(ethHeader->ether_dhost));

    if (header->caplen < sizeof(struct ether_header) + sizeof(struct ip)) {
        return packetDetails + "Packet too short for IP header";
    }

    struct ip *ipHeader = (struct ip *)(packetData + sizeof(struct ether_header));
    if (ntohs(ethHeader->ether_type) != ETHERTYPE_IP) {
        return packetDetails + "Not an IP packet";
    }

    int ipHeaderLen = ipHeader->ip_hl * 4;
    packetDetails += QString("IP Header:\n");
    packetDetails += QString("  Source IP: %1\n").arg(NetworkUtils::ipToString(ipHeader->ip_src));
    packetDetails += QString("  Destination IP: %1\n").arg(NetworkUtils::ipToString(ipHeader->ip_dst));
    packetDetails += QString("  Protocol: %1\n").arg(ipHeader->ip_p);

    if (header->caplen < sizeof(struct ether_header) + ipHeaderLen) {
        return packetDetails + "Packet too short for transport header";
    }

    int payloadOffset = sizeof(struct ether_header) + ipHeaderLen;
    int payloadLen = header->caplen - payloadOffset;

    if (ipHeader->ip_p == IPPROTO_TCP) {
        struct tcphdr *tcpHeader = (struct tcphdr *)(packetData + payloadOffset);
        int tcpHeaderLen = tcpHeader->th_off * 4;
        payloadOffset += tcpHeaderLen;
        payloadLen -= tcpHeaderLen;

        packetDetails += QString("TCP Header:\n");
        packetDetails += QString("  Source Port: %1\n").arg(ntohs(tcpHeader->th_sport));
        packetDetails += QString("  Destination Port: %1\n").arg(ntohs(tcpHeader->th_dport));
        packetDetails += QString("  Flags: %1\n").arg(tcpHeader->th_flags, 0, 16);
        packetDetails += QString("  Window Size: %1\n").arg(ntohs(tcpHeader->th_win));

        // Detect protocols by port
        quint16 srcPort = ntohs(tcpHeader->th_sport);
        quint16 dstPort = ntohs(tcpHeader->th_dport);
        if (dstPort == 80 || srcPort == 80) {
            packetDetails += "Protocol Detected: HTTP\n";
        } else if (dstPort == 443 || srcPort == 443) {
            packetDetails += "Protocol Detected: HTTPS/TLS\n";
        }

        // Parse HTTP payload (unencrypted)
        if (payloadLen > 0 && (dstPort == 80 || srcPort == 80)) {
            // Corrected: Use fromUtf8 to create QString from raw bytes
            QString payload = QString::fromUtf8(reinterpret_cast<const char*>(packetData + payloadOffset), payloadLen);

            // Transaction Amount (e.g., "$100.00", "amount=50.99")
            QRegularExpression amountRegex("[$€£]?\\d+\\.\\d{2}|amount=\\d+\\.\\d{2}");
            QRegularExpressionMatch amountMatch = amountRegex.match(payload);
            if (amountMatch.hasMatch()) {
                packetDetails += QString("Transaction Amount: %1\n").arg(amountMatch.captured(0));
            }

            // Payment Method (e.g., "card=Visa", "method=PayPal")
            QRegularExpression paymentRegex("(card|method)=(\\w+)");
            QRegularExpressionMatch paymentMatch = paymentRegex.match(payload);
            if (paymentMatch.hasMatch()) {
                packetDetails += QString("Payment Method: %1\n").arg(paymentMatch.captured(2));
            }

            // Failed Attempts (e.g., "401 Unauthorized")
            if (payload.contains("401")) {
                packetDetails += QString("Failed Attempts: 1\n");
            }
        }
    } else if (ipHeader->ip_p == IPPROTO_UDP) {
        struct udphdr *udpHeader = (struct udphdr *)(packetData + payloadOffset);
        packetDetails += QString("UDP Header:\n");
        packetDetails += QString("  Source Port: %1\n").arg(ntohs(udpHeader->uh_sport));
        packetDetails += QString("  Destination Port: %1\n").arg(ntohs(udpHeader->uh_dport));
    }

    packetDetails += QString("Payload Length: %1\n").arg(payloadLen);
    return packetDetails;
}
