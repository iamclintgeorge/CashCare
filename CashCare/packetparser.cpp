#include "packetparser.h"
#include "networkutils.h"
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>

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

    if (ipHeader->ip_p == IPPROTO_TCP) {
        struct tcphdr *tcpHeader = (struct tcphdr *)(packetData + sizeof(struct ether_header) + ipHeaderLen);
        packetDetails += QString("TCP Header:\n");
        packetDetails += QString("  Source Port: %1\n").arg(ntohs(tcpHeader->th_sport));
        packetDetails += QString("  Destination Port: %1\n").arg(ntohs(tcpHeader->th_dport));
        packetDetails += QString("  Flags: %1\n").arg(tcpHeader->th_flags, 0, 16);
        packetDetails += QString("  Window Size: %1\n").arg(ntohs(tcpHeader->th_win));
    } else if (ipHeader->ip_p == IPPROTO_UDP) {
        struct udphdr *udpHeader = (struct udphdr *)(packetData + sizeof(struct ether_header) + ipHeaderLen);
        packetDetails += QString("UDP Header:\n");
        packetDetails += QString("  Source Port: %1\n").arg(ntohs(udpHeader->uh_sport));
        packetDetails += QString("  Destination Port: %1\n").arg(ntohs(udpHeader->uh_dport));
    }

    packetDetails += QString("Payload Length: %1\n").arg(header->caplen - (sizeof(struct ether_header) + ipHeaderLen));
    return packetDetails;
}
