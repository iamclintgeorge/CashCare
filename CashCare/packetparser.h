#ifndef PACKETPARSER_H
#define PACKETPARSER_H

#include <QString>
#include <pcap.h>

class PacketParser {
public:
    QString parsePacket(const struct pcap_pkthdr *header, const u_char *packetData);
};

#endif // PACKETPARSER_H
