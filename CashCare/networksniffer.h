#ifndef NETWORKSNIFFER_H
#define NETWORKSNIFFER_H

#include <QObject>
#include <QTimer>
#include <memory>
#include <pcap/pcap.h>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class NetworkSniffer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString packetInfo READ packetInfo NOTIFY packetInfoChanged)
    Q_PROPERTY(int totalPackets READ totalPackets NOTIFY totalPacketsChanged)
public:
    explicit NetworkSniffer(QObject *parent = nullptr);
    ~NetworkSniffer();

    QString packetInfo() const { return m_packetInfo; }
    int totalPackets() const { return m_totalPackets; }

public slots:
    void startSniffing();
    void stopSniffing();

signals:
    void packetInfoChanged();
    void totalPacketsChanged();

private slots:
    void capturePacket();
    void handleGeoReply(QNetworkReply *reply); // Handle API response

private:
    pcap_t *m_pcapHandle;
    std::unique_ptr<QTimer> m_timer;
    QString m_packetInfo;
    int m_totalPackets = 0;
    QNetworkAccessManager *m_networkManager;
    QString m_pendingIp; // Store IP awaiting geolocation
};

#endif
