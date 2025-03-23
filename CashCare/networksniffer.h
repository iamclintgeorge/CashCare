#ifndef NETWORKSNIFFER_H
#define NETWORKSNIFFER_H

#include <QObject>
#include <QTimer>
#include <memory>
#include <pcap/pcap.h>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QMap>

class NetworkSniffer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString packetInfo READ packetInfo NOTIFY packetInfoChanged)
    Q_PROPERTY(int totalPackets READ totalPackets NOTIFY totalPacketsChanged)
    Q_PROPERTY(QString transactionAmount READ transactionAmount NOTIFY transactionAmountChanged)
    Q_PROPERTY(QString paymentMethod READ paymentMethod NOTIFY paymentMethodChanged)
    Q_PROPERTY(int failedAttempts READ failedAttempts NOTIFY failedAttemptsChanged)
    Q_PROPERTY(QString riskNote READ riskNote NOTIFY riskNoteChanged)
    Q_PROPERTY(qreal bandwidth READ bandwidth NOTIFY bandwidthChanged) // Changed to match cpp
    Q_PROPERTY(QString geoInfo READ geoInfo NOTIFY geoInfoChanged)     // Added for geolocation
    Q_PROPERTY(QString threatLevel READ threatLevel NOTIFY threatLevelChanged) // Added for threat level

public:
    explicit NetworkSniffer(QObject *parent = nullptr);
    ~NetworkSniffer();

    QString packetInfo() const { return m_packetInfo; }
    int totalPackets() const { return m_totalPackets; }
    QString transactionAmount() const { return m_transactionAmount; }
    QString paymentMethod() const { return m_paymentMethod; }
    int failedAttempts() const { return m_failedAttempts; }
    QString riskNote() const { return m_riskNote; }
    qreal bandwidth() const { return m_bandwidth; }       // Changed from bandwidthUsage
    QString geoInfo() const { return m_geoInfo; }         // Added
    QString threatLevel() const { return m_threatLevel; } // Added

public slots:
    void startSniffing();
    void stopSniffing();

signals:
    void packetInfoChanged();
    void totalPacketsChanged();
    void transactionAmountChanged();
    void paymentMethodChanged();
    void failedAttemptsChanged();
    void riskNoteChanged();
    void bandwidthChanged();           // Changed from bandwidthUsageChanged
    void geoInfoChanged();             // Added
    void threatLevelChanged();         // Added
    void packetContextUpdated(const QString &packetInfo, const QString &context);

private slots:
    void capturePacket();
    void handleGeoReply(QNetworkReply *reply);
    void handleThreatReply(QNetworkReply *reply);
    void updateBandwidth();

private:
    pcap_t *m_pcapHandle;
    std::unique_ptr<QTimer> m_timer;
    QString m_packetInfo;
    int m_totalPackets = 0;
    QNetworkAccessManager *m_networkManager;
    QString m_pendingIp;
    QString m_transactionAmount = "N/A";
    QString m_paymentMethod = "N/A";
    int m_failedAttempts = 0;
    QString m_riskNote = "No risks detected";
    QMap<QString, int> m_ipConnectionCount;
    qreal m_bandwidth = 0.0;            // Changed from m_bandwidthUsage
    QString m_geoInfo;                  // Added
    QString m_threatLevel;              // Added
    quint64 m_totalBytes = 0;
    QTimer *m_bandwidthTimer;
    qint64 m_lastBandwidthTime = 0;     // Added for bandwidth calculation
    quint64 m_lastBandwidthBytes = 0;   // Added for bandwidth calculation
};

#endif // NETWORKSNIFFER_H
