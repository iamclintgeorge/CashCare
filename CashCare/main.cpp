
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

#ifdef _WIN32
// Define Ethernet header structure for Windows
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

struct tcphdr {
    u_short th_sport;
    u_short th_dport;
    u_int th_seq;
    u_int th_ack;
    u_char th_offx2;
    u_char th_flags;
    u_short th_win;
    u_short th_sum;
    u_short th_urp;
};

struct udphdr {
    u_short uh_sport;
    u_short uh_dport;
    u_short uh_len;
    u_short uh_sum;
};

#define ETHERTYPE_IP 0x0800
#else
#include <net/ethernet.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#endif

class NetworkSniffer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString packetInfo READ packetInfo NOTIFY packetInfoChanged)

public:
    explicit NetworkSniffer(QObject *parent = nullptr)
        : QObject(parent), m_pcapHandle(nullptr), m_networkManager(new QNetworkAccessManager(this)) {
        startSniffing();
    }

    ~NetworkSniffer() {
        stopSniffing();
    }

    QString packetInfo() const {
        return m_packetInfo;
    }

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

        qDebug() << "Available network devices:";
        int i = 0;
        for (pcap_if_t *d = alldevs; d != nullptr; d = d->next) {
            qDebug() << i++ << ":" << d->name << "-" << (d->description ? d->description : "No description");
        }

        int selectedDeviceIndex = 0;
        pcap_if_t *selectedDevice = alldevs;

        for (i = 0; i < selectedDeviceIndex && selectedDevice != nullptr; i++) {
            selectedDevice = selectedDevice->next;
        }

        if (selectedDevice != nullptr) {
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
        } else {
            qWarning() << "Device index" << selectedDeviceIndex << "not found.";
        }

        pcap_freealldevs(alldevs);
    }

    void stopSniffing() {
        if (m_timer) {
            m_timer->stop();
        }
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
            QString packetDetails = parsePacket(header, packetData);
            m_packetInfo = packetDetails;
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
        packetDetails.reserve(1024);

        struct ether_header *ethHeader = (struct ether_header *)packetData;
        packetDetails += QString("Ethernet Header:\n");
        packetDetails += QString("  Source MAC: %1\n").arg(macToString(ethHeader->ether_shost));
        packetDetails += QString("  Destination MAC: %1\n").arg(macToString(ethHeader->ether_dhost));

        if (ntohs(ethHeader->ether_type) == ETHERTYPE_IP) {
            struct ip *ipHeader = (struct ip *)(packetData + sizeof(struct ether_header));
            packetDetails += QString("IP Header:\n");
            packetDetails += QString("  Source IP: %1\n").arg(inet_ntoa(ipHeader->ip_src));
            packetDetails += QString("  Destination IP: %1\n").arg(inet_ntoa(ipHeader->ip_dst));

            int payloadLength = header->len - (sizeof(struct ether_header) + sizeof(struct ip));
            if (payloadLength > 0) {
                packetDetails += QString("Payload Length: %1 bytes\n").arg(payloadLength);
            }

            // Parse TCP/UDP headers
            if (ipHeader->ip_p == IPPROTO_TCP) {
                struct tcphdr *tcpHeader = (struct tcphdr *)(packetData + sizeof(struct ether_header) + sizeof(struct ip));
                packetDetails += QString("TCP Header:\n");
                packetDetails += QString("  Source Port: %1\n").arg(ntohs(tcpHeader->th_sport));
                packetDetails += QString("  Destination Port: %1\n").arg(ntohs(tcpHeader->th_dport));
                packetDetails += QString("  Flags: %1\n").arg(tcpHeader->th_flags);
                packetDetails += QString("  Window Size: %1\n").arg(ntohs(tcpHeader->th_win));
            } else if (ipHeader->ip_p == IPPROTO_UDP) {
                struct udphdr *udpHeader = (struct udphdr *)(packetData + sizeof(struct ether_header) + sizeof(struct ip));
                packetDetails += QString("UDP Header:\n");
                packetDetails += QString("  Source Port: %1\n").arg(ntohs(udpHeader->uh_sport));
                packetDetails += QString("  Destination Port: %1\n").arg(ntohs(udpHeader->uh_dport));
            }

            // Get geolocation
            QString geolocation = getGeolocation(inet_ntoa(ipHeader->ip_src));
            packetDetails += QString("Geolocation: %1\n").arg(geolocation);
        }

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

    QString getGeolocation(const QString &ip) {
        QNetworkRequest request(QUrl(QString("http://ip-api.com/json/%1").arg(ip)));
        QNetworkReply *reply = m_networkManager->get(request);

        QEventLoop loop;
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();

        if (reply->error() == QNetworkReply::NoError) {
            QByteArray response = reply->readAll();
            QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
            QJsonObject jsonObj = jsonDoc.object();

            QString country = jsonObj["country"].toString();
            QString city = jsonObj["city"].toString();
            return QString("%1, %2").arg(city, country);
        } else {
            return "Unknown";
        }
    }
};

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<NetworkSniffer>("com.example", 1, 0, "NetworkSniffer");
    engine.loadFromModule("CashCare", "Main");

    return app.exec();
}

#include "main.moc"
