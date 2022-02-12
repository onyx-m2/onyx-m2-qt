#ifndef CANBUS_H
#define CANBUS_H

#include <QtCore>
#include <QCanBus>
#include <QCanBusDevice>

#include <Network.h>

class Canbus : public QObject
{
    Q_OBJECT
public:
    explicit Canbus(QObject *parent = nullptr);
    void start(const QString& dbcfile);

public slots:
    qreal signal(const QString &name);
    qreal timestamp();

protected:
    QCanBusDevice* connect(int bus, const QString& deviceName);
    void loadDBC(const QString& filename);
    void processMessage(int bus, const QCanBusFrame& frame);

private:
    std::unique_ptr<dbcppp::INetwork> net;
    std::unordered_map<std::string, double> signalMap;
    std::unordered_map<uint64_t, const dbcppp::IMessage*> messageMap;
    QMutex signalMapLock;
    qreal lastReceivedMessageTimestamp;
};

#endif // CANBUS_H
