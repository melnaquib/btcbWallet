#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "vendor.h"
#include "uiproxy.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName(VENDOR_ORG_NAME);
    app.setOrganizationDomain(VENDOR_ORG_DOMAIN);

    app.setApplicationDisplayName(VENDOR_APP_DNAME);
    app.setApplicationName(VENDOR_APP_NAME);
    app.setApplicationVersion(VENDOR_APP_VER);

    QQmlApplicationEngine engine;

    UiProxy proxy;
    engine.rootContext()->setContextProperty("proxy", &proxy);

#ifdef QT_DEBUG
    engine.load(QUrl(QStringLiteral("../btcbWallet/main.qml")));
#else
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
#endif
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
