#include "networksniffer.h"
#include "packetparser.h"
#include <QDebug>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDateTime>
#include <QTimer>
#include <QProcess>

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
    m_bandwidthTimer->start(3000);

    // Delay startSniffing to ensure QML connections are established
    QTimer::singleShot(2000, this, &NetworkSniffer::startSniffing);
}

NetworkSniffer::~NetworkSniffer() {
    stopSniffing();
}

void NetworkSniffer::startSniffing() {
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_if_t *alldevs;

#ifdef SIMULATION_MODE
    qDebug() << "Starting with one simulated fraudulent packet";

    QString fakePacket = "Captured IP Packet:\n"
                         "  Source IP: 185.107.70.202\n"
                         "  Destination IP: 192.168.1.1\n"
                         "  Protocol: TCP\n"
                         "  Source Port: 12345\n"
                         "  Destination Port: 443\n"
                         "  Payload Length: 512\n"
                         "Additional Data:\n"
                         "  Transaction Amount: $500\n"
                         "  Payment Method: Credit Card\n"
                         "  Failed Attempts: 3";
    m_packetInfo = fakePacket;
    m_totalPackets = 1;
    m_totalBytes += 512;

    QJsonObject txnJson;
    QDateTime now = QDateTime::currentDateTime();
    txnJson["amt"] = 500.0;
    txnJson["merchant"] = "Tichkule&TichkuleCo";
    txnJson["category"] = "electronics";
    txnJson["gender"] = "unknown";
    txnJson["job"] = "unknown";
    txnJson["city"] = "unknown";
    txnJson["state"] = "unknown";
    txnJson["lat"] = 40.7128;
    txnJson["long"] = -74.0060;
    txnJson["city_pop"] = 100;
    txnJson["unix_time"] = now.toSecsSinceEpoch();
    txnJson["merch_lat"] = 34.0522;
    txnJson["merch_long"] = -118.2437;
    txnJson["age"] = 0;
    txnJson["distance"] = 2700.0;
    txnJson["day_of_week"] = now.date().dayOfWeek();
    txnJson["hour"] = now.time().hour();
    txnJson["month"] = now.date().month();
    txnJson["zip"] = "99999";
    QString jsonStr = QString(QJsonDocument(txnJson).toJson(QJsonDocument::Compact));

    // Simulate ML prediction for testing (hardcoded fraud)
    bool isFraudulent = true;
    float fraudProb = 0.95;
    m_riskNote = QString("ML Fraud Prediction: %1 (Prob: %2); ").arg(isFraudulent ? "Fraud" : "Non-Fraud").arg(fraudProb, 0, 'f', 2);
    qDebug() << "Simulated ML Output: 1,0.95 (hardcoded for simulation)";

    emit totalPacketsChanged();
    emit riskNoteChanged();
    emit packetInfoChanged();

    QString fullPacketInfo = QString("Captured IP Packet #%1:\n%2\n%3")
                                 .arg(m_totalPackets).arg(m_packetInfo).arg(m_riskNote);
    qDebug() << "Full Packet Info for LLM:\n" << fullPacketInfo;

    QString context = "This packet may indicate phishing due to a known fraudulent IP (185.107.70.202) and high transaction amount.";
    qDebug() << "Hardcoded LLM Context:\n" << context;
    emit packetContextUpdated("1", context);

    QTimer::singleShot(1000, this, [this]() {
        char errbuf[PCAP_ERRBUF_SIZE];
        pcap_if_t *alldevs;

        if (pcap_findalldevs(&alldevs, errbuf) == -1) {
            qWarning() << "Error finding devices:" << errbuf;
            return;
        }
        pcap_if_t *selectedDevice = alldevs;
        const char *device = selectedDevice->name;
        qDebug() << "Switching to real sniffing on device:" << device;

        m_pcapHandle = pcap_open_live(device, BUFSIZ, 1, 1000, errbuf);
        if (!m_pcapHandle) {
            qWarning() << "Failed to open device:" << errbuf;
            pcap_freealldevs(alldevs);
            return;
        }

        m_timer = std::make_unique<QTimer>(this);
        connect(m_timer.get(), &QTimer::timeout, this, &NetworkSniffer::capturePacket);
        m_timer->start(3000);
        pcap_freealldevs(alldevs);
    });
#else
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
    m_timer->start(3000);
    pcap_freealldevs(alldevs);
#endif
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
            m_totalBytes += header->len;
            emit totalPacketsChanged();

            QStringList lines = m_packetInfo.split("\n");
            QString sourceIp, destIp, protocol, domain;
            int destPort = 0, payloadLen = 0;

            for (const QString &line : lines) {
                if (line.startsWith("  Source IP:")) sourceIp = line.split(":")[1].trimmed();
                if (line.startsWith("  Destination IP:")) destIp = line.split(":")[1].trimmed();
                if (line.startsWith("  Destination Port:")) destPort = line.split(":")[1].trimmed().toInt();
                if (line.startsWith("Payload Length:")) payloadLen = line.split(":")[1].trimmed().toInt();
                if (line.startsWith("Protocol Detected:")) protocol = line.split(":")[1].trimmed();
                if (line.startsWith("DNS Query:")) domain = line.split(":")[1].trimmed();
                if (line.startsWith("Transaction Amount:")) m_transactionAmount = line.split(":")[1].trimmed();
                if (line.startsWith("Payment Method:")) m_paymentMethod = line.split(":")[1].trimmed();
                if (line.startsWith("Failed Attempts:")) m_failedAttempts = line.split(":")[1].trimmed().toInt();
            }

            bool hasFinancialData = !m_transactionAmount.contains("N/A") || m_failedAttempts > 0;
            bool isFraudulent = false;
            float fraudProb = 0.0;

            if (hasFinancialData) {
                QJsonObject txnJson;
                QDateTime now = QDateTime::currentDateTime();
                txnJson["amt"] = m_transactionAmount.remove("$").toDouble();
                txnJson["merchant"] = "unknown";
                txnJson["category"] = "misc";
                txnJson["gender"] = "unknown";
                txnJson["job"] = "unknown";
                txnJson["city"] = "unknown";
                txnJson["state"] = "unknown";
                txnJson["lat"] = 0.0;
                txnJson["long"] = 0.0;
                txnJson["city_pop"] = 0;
                txnJson["unix_time"] = now.toSecsSinceEpoch();
                txnJson["merch_lat"] = 0.0;
                txnJson["merch_long"] = 0.0;
                txnJson["age"] = 0;
                txnJson["distance"] = 0.0;
                txnJson["day_of_week"] = now.date().dayOfWeek(); // 1-7 (Mon-Sun)
                txnJson["hour"] = now.time().hour();             // 0-23
                txnJson["month"] = now.date().month();           // 1-12
                txnJson["zip"] = "00000";                        // Placeholder
                QString jsonStr = QString(QJsonDocument(txnJson).toJson(QJsonDocument::Compact));

                QProcess process;
                process.start("python3", QStringList() << "/home/clint/Desktop/cashcare/CashCare/ml_predict.py" << jsonStr);
                process.waitForFinished(2000);
                QString mlOutput = process.readAllStandardOutput().trimmed();
                qDebug() << "ML Output:" << mlOutput;
                QString mlError = process.readAllStandardError().trimmed();
                qDebug() << "ML Error:" << mlError;
                QStringList mlResult = mlOutput.split(",");
                if (mlResult.size() == 2 && !mlResult[0].isEmpty()) {
                    isFraudulent = mlResult[0].toInt() == 1;
                    fraudProb = mlResult[1].toFloat();
                    m_riskNote = QString("ML Fraud Prediction: %1 (Prob: %2); ").arg(isFraudulent ? "Fraud" : "Non-Fraud").arg(fraudProb, 0, 'f', 2);
                } else {
                    m_riskNote = "ML Error; ";
                }
            } else {
                m_riskNote = "No financial data; ";
            }

            m_ipConnectionCount[sourceIp] = m_ipConnectionCount.value(sourceIp, 0) + 1;
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

                QUrl geoUrl("http://ip-api.com/json/" + sourceIp + "?fields=country,city");
                m_networkManager->get(QNetworkRequest(geoUrl));
            }

            if (hasFinancialData && isFraudulent) {
                QJsonObject packetJson;
                packetJson["prompt"] = "Analyze this for financial fraud risk:\n" + fullPacketInfo;
                QJsonDocument doc(packetJson);
                QByteArray jsonData = doc.toJson();
                QNetworkRequest request(QUrl("http://localhost:3600/generate"));
                request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
                qDebug() << "Sending LLM request with:" << jsonData;
                QNetworkReply *reply = m_networkManager->post(request, jsonData);
                connect(reply, &QNetworkReply::finished, this, [this, reply]() {
                    qDebug() << "LLM Reply Error:" << reply->errorString();
                    if (reply->error() == QNetworkReply::NoError) {
                        QString context = reply->readAll().replace("Response: \n", "");
                        qDebug() << "LLM Context:\n" << context;
                        emit packetContextUpdated(QString::number(m_totalPackets), context);
                    } else {
                        qWarning() << "LLM error:" << reply->errorString();
                        emit packetContextUpdated(QString::number(m_totalPackets), "Error: " + reply->errorString());
                    }
                    reply->deleteLater();
                });
            }

            emit packetInfoChanged();
            emit riskNoteChanged();
        }
    }
}

void NetworkSniffer::stopSniffing() {
    if (m_timer) {
        m_timer->stop();
    }
    if (m_pcapHandle) {
        pcap_close(m_pcapHandle);
        m_pcapHandle = nullptr;
    }
}

void NetworkSniffer::updateBandwidth() {
    quint64 currentBytes = m_totalBytes;
    qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
    qint64 timeDiff = currentTime - m_lastBandwidthTime;

    if (timeDiff > 0) {
        quint64 bytesDiff = currentBytes - m_lastBandwidthBytes;
        double bandwidth = (bytesDiff * 1000.0) / timeDiff;
        m_bandwidth = bandwidth;
        emit bandwidthChanged();
    }

    m_lastBandwidthBytes = currentBytes;
    m_lastBandwidthTime = currentTime;
}

void NetworkSniffer::handleGeoReply(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Geo Reply Data:" << data;
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject obj = doc.object();
            QString country = obj["country"].toString();
            QString city = obj["city"].toString();

            // More structured format for display
            if (!country.isEmpty() && !city.isEmpty()) {
                m_geoInfo = QString("%1, %2").arg(city, country);
            } else if (!country.isEmpty()) {
                m_geoInfo = country;
            } else if (!city.isEmpty()) {
                m_geoInfo = city;
            } else {
                m_geoInfo = "Unknown Location";
            }

            qDebug() << "Geo Info Updated:" << m_geoInfo;
            emit geoInfoChanged();
        } else {
            qWarning() << "Invalid Geo JSON:" << data;
        }
    } else {
        qWarning() << "Geo Reply Error:" << reply->errorString();
    }
    reply->deleteLater();
}

void NetworkSniffer::handleThreatReply(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Threat Reply Data:" << data;
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject obj = doc.object()["data"].toObject();
            int abuseScore = obj["abuseConfidenceScore"].toInt();

            // Set threat level based on score
            if (abuseScore > 50) {
                m_threatLevel = "High";
            } else if (abuseScore > 20) {
                m_threatLevel = "Medium";
            } else {
                m_threatLevel = "Low";
            }

            // Add score to the threat level for more information
            m_threatLevel = QString("%1 (%2%)").arg(m_threatLevel).arg(abuseScore);

            qDebug() << "Threat Level Updated:" << m_threatLevel;
            emit threatLevelChanged();

            // If high threat, update the risk note too
            if (abuseScore > 50) {
                m_riskNote += "High threat IP detected; ";
                emit riskNoteChanged();
            }
        } else {
            qWarning() << "Invalid Threat JSON:" << data;
        }
    } else {
        qWarning() << "Threat Reply Error:" << reply->errorString();
    }
    reply->deleteLater();
}
