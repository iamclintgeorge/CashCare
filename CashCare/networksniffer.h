#ifndef NETWORKSNIFFER_H
#define NETWORKSNIFFER_H

#include <QObject>
#include <QTimer>
#include <memory>
#include <pcap/pcap.h>
#include <QNetworkAccessManager>

class NetworkSniffer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString packetInfo READ packetInfo NOTIFY packetInfoChanged)
    Q_PROPERTY(int totalPackets READ totalPackets NOTIFY totalPacketsChanged)
    Q_PROPERTY(int blockedPackets READ blockedPackets NOTIFY blockedPacketsChanged)
    Q_PROPERTY(qreal bandwidthUsage READ bandwidthUsage NOTIFY bandwidthUsageChanged)
public:
    explicit NetworkSniffer(QObject *parent = nullptr);
    ~NetworkSniffer();

    QString packetInfo() const { return m_packetInfo; }
    int totalPackets() const { return m_totalPackets; }
    int blockedPackets() const { return m_blockedPackets; }
    qreal bandwidthUsage() const { return m_bandwidthUsage; }

public slots:
    void startSniffing();
    void stopSniffing();

signals:
    void packetInfoChanged();
    void totalPacketsChanged();
    void blockedPacketsChanged();
    void bandwidthUsageChanged();

private slots:
    void capturePacket();

private:
    pcap_t *m_pcapHandle;
    std::unique_ptr<QTimer> m_timer;
    QString m_packetInfo;
    int m_totalPackets = 0;
    int m_blockedPackets = 0;
    qreal m_bandwidthUsage = 0.0;
    QNetworkAccessManager *m_networkManager;
};

#endif
