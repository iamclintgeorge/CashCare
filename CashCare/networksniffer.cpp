#include "networksniffer.h"
#include "packetparser.h"
#include <QDebug>

NetworkSniffer::NetworkSniffer(QObject *parent)
    : QObject(parent), m_pcapHandle(nullptr), m_networkManager(new QNetworkAccessManager(this)) {
    startSniffing();
}

NetworkSniffer::~NetworkSniffer() {
    stopSniffing();
}

void NetworkSniffer::startSniffing() {
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_if_t *alldevs;

    if (pcap_findalldevs(&alldevs, errbuf) == -1) {
        qWarning() << "Error finding devices:" << errbuf;
        return;
    }

    pcap_if_t *selectedDevice = alldevs;
    const char *device = selectedDevice->name;
    qDebug() << "Sniffing on device:" << device;

    m_pcapHandle = pcap_open_live(device, BUFSIZ, 1, 1000, errbuf);
    if (!m_pcapHandle) {
        qWarning() << "Failed to open device:" << errbuf;
        pcap_freealldevs(alldevs);
        return;
    }

    m_timer = std::make_unique<QTimer>(this);
    connect(m_timer.get(), &QTimer::timeout, this, &NetworkSniffer::capturePacket);
    m_timer->start(1000);

    pcap_freealldevs(alldevs);
}

void NetworkSniffer::stopSniffing() {
    if (m_timer) m_timer->stop();
    if (m_pcapHandle) {
        pcap_close(m_pcapHandle);
        m_pcapHandle = nullptr;
    }
}

void NetworkSniffer::capturePacket() {
    struct pcap_pkthdr *header;
    const u_char *packetData;
    int result = pcap_next_ex(m_pcapHandle, &header, &packetData);

    if (result == 1) {
        PacketParser parser;
        m_packetInfo = parser.parsePacket(header, packetData);
        m_totalPackets++;
        emit packetInfoChanged();
        emit totalPacketsChanged();
        // Add logic to determine if packet is blocked and update m_blockedPackets
        // Update m_bandwidthUsage based on header->len if desired
    } else {
        m_packetInfo = (result == 0) ? "No packet captured" : "Error capturing packet";
        emit packetInfoChanged();
    }
}
