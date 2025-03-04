#include "packetparser.h"
#include "networkutils.h"
#include <netinet/ip.h>

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

    packetDetails += QString("IP Header:\n");
    packetDetails += QString("  Source IP: %1\n").arg(NetworkUtils::ipToString(ipHeader->ip_src));
    packetDetails += QString("  Destination IP: %1\n").arg(NetworkUtils::ipToString(ipHeader->ip_dst));

    return packetDetails;
}
