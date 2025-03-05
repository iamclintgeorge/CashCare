#include "networksniffer.h"
#include "packetparser.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>

NetworkSniffer::NetworkSniffer(QObject *parent)
    : QObject(parent), m_pcapHandle(nullptr), m_networkManager(new QNetworkAccessManager(this)) {
    connect(m_networkManager, &QNetworkAccessManager::finished, this, &NetworkSniffer::handleGeoReply);
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

        // Extract source IP for geolocation
        QStringList lines = m_packetInfo.split("\n");
        for (const QString &line : lines) {
            if (line.startsWith("  Source IP:")) {
                m_pendingIp = line.split(":")[1].trimmed();
                QUrl url("http://ip-api.com/json/" + m_pendingIp + "?fields=country,city");
                m_networkManager->get(QNetworkRequest(url));
                break;
            }
        }

        qDebug() << "Captured Packet #" << m_totalPackets << ":\n" << m_packetInfo;
        emit packetInfoChanged();
        emit totalPacketsChanged();
    } else {
        m_packetInfo = (result == 0) ? "No packet captured" : "Error capturing packet";
        qDebug() << "Packet capture failed:" << m_packetInfo;
        emit packetInfoChanged();
    }
}

void NetworkSniffer::handleGeoReply(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject obj = doc.object();
            QString geo = QString("Geolocation: %1, %2").arg(obj["country"].toString(), obj["city"].toString());
            m_packetInfo += "\n" + geo;
            qDebug() << "Geolocation for IP" << m_pendingIp << ":" << geo;
            emit packetInfoChanged(); // Update QML with geolocation
        } else {
            qWarning() << "Failed to parse geolocation JSON:" << response;
        }
    } else {
        qWarning() << "Geolocation request failed:" << reply->errorString();
    }
    reply->deleteLater();
}
