#include "networksniffer.h"
#include "packetparser.h"
#include <QDebug>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDateTime>

NetworkSniffer::NetworkSniffer(QObject *parent)
    : QObject(parent), m_pcapHandle(nullptr), m_networkManager(new QNetworkAccessManager(this)),
    m_bandwidthTimer(new QTimer(this)) {
    connect(m_networkManager, &QNetworkAccessManager::finished, this, [this](QNetworkReply *reply) {
        if (reply->url().toString().contains("ip-api.com")) {
            handleGeoReply(reply);
        } else if (reply->url().toString().contains("abuseipdb.com")) {
            handleThreatReply(reply);
        }
    });
    connect(m_bandwidthTimer, &QTimer::timeout, this, &NetworkSniffer::updateBandwidth);
    m_bandwidthTimer->start(1000); // Update bandwidth every second
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
    if (m_bandwidthTimer) m_bandwidthTimer->stop();
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
        if (!m_packetInfo.contains("Not an IP packet") && !m_packetInfo.contains("Packet too short")) {
            m_totalPackets++;
            m_totalBytes += header->len; // Accumulate packet size
            emit totalPacketsChanged();

            QStringList lines = m_packetInfo.split("\n");
            QString sourceIp, destIp, protocol, domain;
            int destPort = 0, payloadLen = 0;

            for (const QString &line : lines) {
                if (line.startsWith("  Source IP:")) sourceIp = line.split(":")[1].trimmed();
                if (line.startsWith("  Destination IP:")) destIp = line.split(":")[1].trimmed();
                if (line.startsWith("  Destination Port:")) destPort = line.split(":")[1].trimmed().toInt();
                if (line.startsWith("Protocol Detected:")) protocol = line.split(":")[1].trimmed();
                if (line.startsWith("Payload Length:")) payloadLen = line.split(":")[1].trimmed().toInt();
                if (line.startsWith("DNS Query:")) domain = line.split(":")[1].trimmed();
                if (line.startsWith("Transaction Amount:")) m_transactionAmount = line.split(":")[1].trimmed();
                if (line.startsWith("Payment Method:")) m_paymentMethod = line.split(":")[1].trimmed();
                if (line.startsWith("Failed Attempts:")) m_failedAttempts = line.split(":")[1].trimmed().toInt();
            }

            m_ipConnectionCount[sourceIp] = m_ipConnectionCount.value(sourceIp, 0) + 1;
            m_riskNote = "Risk Analysis: ";
            if (destPort != 80 && destPort != 443) m_riskNote += "Unusual port; ";
            if (m_ipConnectionCount[sourceIp] > 10) m_riskNote += "High connection frequency; ";
            if (QDateTime::currentDateTime().time().hour() < 6 || QDateTime::currentDateTime().time().hour() > 22) {
                m_riskNote += "Outside typical hours; ";
            }
            if (domain.contains("paypa1") || domain.contains("bank0f")) m_riskNote += "Suspicious domain; ";
            if (m_riskNote == "Risk Analysis: ") m_riskNote = "No risks detected";

            QString fullPacketInfo = QString("Captured IP Packet #%1:\n%2\nAdditional Data:\n  Transaction Amount: %3\n  Payment Method: %4\n  Failed Attempts: %5\n%6")
                                         .arg(m_totalPackets)
                                         .arg(m_packetInfo)
                                         .arg(m_transactionAmount)
                                         .arg(m_paymentMethod)
                                         .arg(m_failedAttempts)
                                         .arg(m_riskNote);
            qDebug() << fullPacketInfo;

            if (!sourceIp.isEmpty()) {
                QUrl threatUrl("https://api.abuseipdb.com/api/v2/check?ipAddress=" + sourceIp);
                QNetworkRequest threatRequest(threatUrl);
                threatRequest.setRawHeader("Key", "7a1c9986e975911f7f1272714213961646a4f57afe14cd870342ef8342d851eac5e17616841f544e");
                threatRequest.setRawHeader("Accept", "application/json");
                m_networkManager->get(threatRequest);
            }

            if (!sourceIp.isEmpty()) {
                QUrl geoUrl("http://ip-api.com/json/" + sourceIp + "?fields=country,city");
                m_networkManager->get(QNetworkRequest(geoUrl));
            }

            QJsonObject packetJson;
            packetJson["prompt"] = "Analyze this for financial fraud risk:\n" + fullPacketInfo;
            QJsonDocument doc(packetJson);
            QByteArray jsonData = doc.toJson();

            QNetworkRequest request(QUrl("http://localhost:3600/generate"));
            request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
            QNetworkReply *reply = m_networkManager->post(request, jsonData);
            connect(reply, &QNetworkReply::finished, this, [reply]() {
                if (reply->error() == QNetworkReply::NoError) {
                    qDebug() << "Server Response:\n" << reply->readAll();
                } else {
                    qWarning() << "Server error:" << reply->errorString();
                }
                reply->deleteLater();
            });

            emit packetInfoChanged();
            emit riskNoteChanged();
        }
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
            if (obj["country"].toString() == "Russia" || obj["country"].toString() == "Nigeria") {
                m_riskNote += "High-risk country; ";
                emit riskNoteChanged();
            }
            qDebug() << "Geolocation for IP" << m_pendingIp << ":" << geo;
            emit packetInfoChanged();
        }
    }
    reply->deleteLater();
}

void NetworkSniffer::handleThreatReply(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject obj = doc.object();
            int abuseScore = obj["data"].toObject()["abuseConfidenceScore"].toInt();
            if (abuseScore > 50) {
                m_riskNote += "High abuse score (" + QString::number(abuseScore) + "); ";
                emit riskNoteChanged();
            }
            qDebug() << "Threat Intel for IP:" << reply->url().query() << "Score:" << abuseScore;
        }
    }
    reply->deleteLater();
}

void NetworkSniffer::updateBandwidth() {
    // Calculate bandwidth in KB/s (bytes per second / 1024)
    qreal bytesPerSecond = m_totalBytes / 1.0; // 1-second interval
    m_bandwidthUsage = bytesPerSecond / 1024.0;
    m_totalBytes = 0; // Reset after calculation
    emit bandwidthUsageChanged();
}
