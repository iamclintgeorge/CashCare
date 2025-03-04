#ifndef NETWORKSNIFFER_H
#define NETWORKSNIFFER_H

#include <QObject>
#include <QTimer>
#include <QNetworkAccessManager>
#include <pcap.h>

class NetworkSniffer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString packetInfo READ packetInfo NOTIFY packetInfoChanged)

public:
    explicit NetworkSniffer(QObject *parent = nullptr);
    ~NetworkSniffer();
    QString packetInfo() const;

signals:
    void packetInfoChanged();

private:
    QString m_packetInfo;
    pcap_t *m_pcapHandle;
    QNetworkAccessManager *m_networkManager;
    std::unique_ptr<QTimer> m_timer;

    void startSniffing();
    void stopSniffing();
    void capturePacket();
};

#endif // NETWORKSNIFFER_H
