#ifndef NETWORKUTILS_H
#define NETWORKUTILS_H

#include <QString>
#include <arpa/inet.h>

class NetworkUtils {
public:
    static QString macToString(const u_char *mac);
    static QString ipToString(const struct in_addr &ip);
};

#endif // NETWORKUTILS_H
