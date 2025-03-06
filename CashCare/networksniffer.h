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
    Q_PROPERTY(QString transactionAmount READ transactionAmount NOTIFY transactionAmountChanged)
    Q_PROPERTY(QString paymentMethod READ paymentMethod NOTIFY paymentMethodChanged)
    Q_PROPERTY(int failedAttempts READ failedAttempts NOTIFY failedAttemptsChanged)
public:
    explicit NetworkSniffer(QObject *parent = nullptr);
    ~NetworkSniffer();

    QString packetInfo() const { return m_packetInfo; }
    int totalPackets() const { return m_totalPackets; }
    QString transactionAmount() const { return m_transactionAmount; }
    QString paymentMethod() const { return m_paymentMethod; }
    int failedAttempts() const { return m_failedAttempts; }

public slots:
    void startSniffing();
    void stopSniffing();

signals:
    void packetInfoChanged();
    void totalPacketsChanged();
    void transactionAmountChanged();
    void paymentMethodChanged();
    void failedAttemptsChanged();

private slots:
    void capturePacket();
    void handleGeoReply(QNetworkReply *reply);

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
};

#endif
