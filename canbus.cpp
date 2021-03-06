#include <fstream>
#include <string>
#include <unordered_map>

#include "canbus.h"

const uint8_t VEH_BUS = 0;
const uint8_t CH_BUS = 1;
std::unordered_map<std::string, uint8_t> BUSES = {
    { "VEH", VEH_BUS},
    { "CH", CH_BUS }
};

#ifdef _WIN32
const char* CAN_PLUGIN = "virtualcan";
#else
const char* CAN_PLUGIN = "socketcan";
#endif

Canbus::Canbus(QObject *parent) : QObject(parent) {
}

qreal Canbus::signal(const QString &name) {
    QMutexLocker locker(&signalMapLock);
    return signalMap[name.toStdString()];
}

qreal Canbus::timestamp() {
    return lastReceivedMessageTimestamp;
}

void Canbus::start(const QString& dbcfile) {
    QThread *thread = QThread::create([=] {
        QString err;
        const QList<QCanBusDeviceInfo> devices = QCanBus::instance()->availableDevices(CAN_PLUGIN, &err);
        if (!err.isEmpty()) {
            qDebug() << "CAN device scanning error:" << err;
        }
        if (devices.size() > 0) {
            loadDBC(dbcfile);
            connect(VEH_BUS, devices.at(0).name());
            connect(CH_BUS, devices.at(1).name());

            QEventLoop eventLoop;
            qDebug() << "CAN reading event loop starting";
            eventLoop.exec();
        }
    });
    thread->start();
}

QCanBusDevice* Canbus::connect(int bus, const QString& deviceName) {
    QString err;
    QCanBusDevice* device = QCanBus::instance()->createDevice(CAN_PLUGIN, deviceName, &err);
    if (device == nullptr) {
        qDebug() << "CAN error creating " << deviceName << "device:" << err;
        return nullptr;
    }
    if (!device->connectDevice()) {
        qDebug() << "CAN error connecting to" << deviceName;
        return nullptr;
    }
    qDebug() << "CAN bus" << bus << "successfully connected to" << deviceName;
    QObject::connect(device, &QCanBusDevice::framesReceived, [=]() {
        for (auto& f: device->readAllFrames()) {
            processMessage(bus, f);
        }
    });
    return device;
}

void Canbus::loadDBC(const QString& filename) {
    std::ifstream idbc(filename.toStdString());
    net = dbcppp::INetwork::LoadDBCFromIs(idbc);
    QMutexLocker locker(&signalMapLock);
    for (const dbcppp::IMessage& msg : net->Messages()) {
        messageMap.insert(std::make_pair(msg.Id(), &msg));
        for (const dbcppp::ISignal& sig : msg.Signals()) {
            signalMap.insert(std::make_pair(sig.Name(), 0));
        }
    }
}

void Canbus::processMessage(int bus, const QCanBusFrame& frame) {
    auto it = messageMap.find(frame.frameId());
    if (it != messageMap.end()) {
        QMutexLocker locker(&signalMapLock);
        QCanBusFrame::TimeStamp ts = frame.timeStamp();
        lastReceivedMessageTimestamp = ts.seconds() + (qreal)ts.microSeconds() / 1000000;
        const dbcppp::IMessage* msg = it->second;
        if (bus == BUSES[msg->Transmitter()]) {
            for (const dbcppp::ISignal& sig : msg->Signals()) {
                QByteArray payload = frame.payload();
                const dbcppp::ISignal* mux_sig = msg->MuxSignal();
                if (sig.MultiplexerIndicator() != dbcppp::ISignal::EMultiplexer::MuxValue ||
                    (mux_sig && mux_sig->Decode(payload) == sig.MultiplexerSwitchValue())) {
                    signalMap[sig.Name()] = sig.RawToPhys(sig.Decode(payload));
                }
            }
        }
    }
}
