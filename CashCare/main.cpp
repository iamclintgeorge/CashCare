#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "networksniffer.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<NetworkSniffer>("com.example", 1, 0, "NetworkSniffer");
    engine.loadFromModule("CashCare", "Main");

    if (engine.rootObjects().isEmpty()) {
        return 1;
    }

    return app.exec();
}
