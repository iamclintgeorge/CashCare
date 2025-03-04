#include "networkutils.h"

QString NetworkUtils::macToString(const u_char *mac) {
    return QString("%1:%2:%3:%4:%5:%6")
    .arg(mac[0], 2, 16, QChar('0'))
        .arg(mac[1], 2, 16, QChar('0'))
        .arg(mac[2], 2, 16, QChar('0'))
        .arg(mac[3], 2, 16, QChar('0'))
        .arg(mac[4], 2, 16, QChar('0'))
        .arg(mac[5], 2, 16, QChar('0'));
}

QString NetworkUtils::ipToString(const struct in_addr &ip) {
    return QString(inet_ntoa(ip));
}
