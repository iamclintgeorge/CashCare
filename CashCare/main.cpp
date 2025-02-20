#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#include <QDebug>
#include <pcap.h>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDateTime>
#include <memory>
#include <map>
#include <QList>
#include <QString>
#include <QVariantList>
#include <QVariantMap>

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>

struct ether_header {
    u_char ether_dhost[6];
    u_char ether_shost[6];
    u_short ether_type;
};

struct ip {
    u_char ip_hl:4;
    u_char ip_v:4;
    u_char ip_tos;
    u_short ip_len;
    u_short ip_id;
    u_short ip_off;
    u_char ip_ttl;
    u_char ip_p;
    u_short ip_sum;
    struct in_addr ip_src;
    struct in_addr ip_dst;
};

#define ETHERTYPE_IP 0x0800
#else
#include <net/ethernet.h>
#include <netinet/ip.h>
#endif

struct FirewallRule {
    QString sourceIp;
    quint16 port;
    QString protocol;
    QString action;
};

class NetworkSniffer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString packetInfo READ packetInfo NOTIFY packetInfoChanged)
public:
    explicit NetworkSniffer(QObject *parent = nullptr)
        : QObject(parent), m_pcapHandle(nullptr), m_networkManager(new QNetworkAccessManager(this)) {
        startSniffing();
    }

    ~NetworkSniffer() { stopSniffing(); }

    QString packetInfo() const { return m_packetInfo; }

signals:
    void packetInfoChanged();

private:
    QString m_packetInfo;
    pcap_t *m_pcapHandle;
    QNetworkAccessManager *m_networkManager;
    std::unique_ptr<QTimer> m_timer;

    void startSniffing() {
        char errbuf[PCAP_ERRBUF_SIZE];
        pcap_if_t *alldevs;

        if (pcap_findalldevs(&alldevs, errbuf) == -1) {
            qWarning() << "Error finding devices:" << errbuf;
            return;
        }

        int deviceCount = 0;
        pcap_if_t *d = alldevs;
        for (; d != nullptr; d = d->next) {
            qDebug() << deviceCount++ << ":" << d->name << "-" << (d->description ? d->description : "No description");
        }

        int selectedDeviceIndex = 0; // Default to first device
        if (deviceCount == 0) {
            qWarning() << "No network devices found.";
            pcap_freealldevs(alldevs);
            return;
        }

        pcap_if_t *selectedDevice = alldevs;
        for (int i = 0; i < selectedDeviceIndex && selectedDevice != nullptr; i++) {
            selectedDevice = selectedDevice->next;
        }

        const char *device = selectedDevice->name;
        qDebug() << "Selected device:" << device;

        m_pcapHandle = pcap_open_live(device, BUFSIZ, 1, 1000, errbuf);
        if (m_pcapHandle == nullptr) {
            qWarning() << "Could not open device:" << errbuf;
        } else {
            m_timer = std::make_unique<QTimer>(this);
            connect(m_timer.get(), &QTimer::timeout, this, &NetworkSniffer::capturePacket);
            m_timer->start(1000);
        }

        pcap_freealldevs(alldevs);
    }

    void stopSniffing() {
        if (m_timer) m_timer->stop();
        if (m_pcapHandle) {
            pcap_close(m_pcapHandle);
            m_pcapHandle = nullptr;
        }
    }

    void capturePacket() {
        struct pcap_pkthdr *header;
        const u_char *packetData;
        int result = pcap_next_ex(m_pcapHandle, &header, &packetData);
        if (result == 1) {
            m_packetInfo = parsePacket(header, packetData);
            emit packetInfoChanged();
        } else if (result == 0) {
            m_packetInfo = "No packet captured";
            emit packetInfoChanged();
        } else {
            m_packetInfo = "Error capturing packet";
            emit packetInfoChanged();
        }
    }

    QString parsePacket(const struct pcap_pkthdr *header, const u_char *packetData) {
        QString packetDetails;
        if (header->caplen < sizeof(struct ether_header)) {
            return "Packet too short for Ethernet header";
        }

        struct ether_header *ethHeader = (struct ether_header *)packetData;
        packetDetails += QString("Ethernet Header:\n");
        packetDetails += QString("  Source MAC: %1\n").arg(macToString(ethHeader->ether_shost));
        packetDetails += QString("  Destination MAC: %1\n").arg(macToString(ethHeader->ether_dhost));

        if (header->caplen < sizeof(struct ether_header) + sizeof(struct ip)) {
            return packetDetails + "Packet too short for IP header";
        }

        struct ip *ipHeader = (struct ip *)(packetData + sizeof(struct ether_header));
        if (ntohs(ethHeader->ether_type) != ETHERTYPE_IP) {
            return packetDetails + "Not an IP packet";
        }

        char ipAddr[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, &ipHeader->ip_src, ipAddr, sizeof(ipAddr));
        packetDetails += QString("IP Header:\n");
        packetDetails += QString("  Source IP: %1\n").arg(QString(ipAddr));
        packetDetails += QString("  Destination IP: %1\n").arg(QString(inet_ntoa(ipHeader->ip_dst)));
        return packetDetails;
    }

    QString macToString(const u_char *mac) {
        return QString("%1:%2:%3:%4:%5:%6")
        .arg(mac[0], 2, 16, QChar('0'))
            .arg(mac[1], 2, 16, QChar('0'))
            .arg(mac[2], 2, 16, QChar('0'))
            .arg(mac[3], 2, 16, QChar('0'))
            .arg(mac[4], 2, 16, QChar('0'))
            .arg(mac[5], 2, 16, QChar('0'));
    }
};

int main(int argc, char *argv[]) {
#ifdef _WIN32
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        qWarning() << "WSAStartup failed";
        return 1;
    }
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<NetworkSniffer>("com.example", 1, 0, "NetworkSniffer");
    engine.loadFromModule("CashCare", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QML module 'CashCare.Main'";
        return 1;
    }
    return app.exec();
}

#include "main.moc"
