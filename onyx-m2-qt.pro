QT += quick serialbus

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        canbus.cpp \
        main.cpp

RESOURCES +=

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

win32: LIBS += -L$$PWD/dbcppp/build/src/libdbcppp/Release/ -llibdbcppp
unix: LIBS += -L/home/john/dbcppp/build -L/home/john/dbcppp/build/src/libdbcppp -ldbcppp

INCLUDEPATH += $$PWD/dbcppp/include/dbcppp
DEPENDPATH += $$PWD/dbcppp/include/dbcppp

HEADERS += \
    canbus.h

DISTFILES += \
    qml/App.qml \
    qml/App_absolute.qml \
    qml/ArcGauge.qml \
    qml/Banner.qml \
    qml/Components/ArcGauge.qml \
    qml/Components/qmldir \
    qml/CustomShape.qml \
    qml/Error.qml \
    qml/Gauges/ArcGauge.qml \
    qml/Gauges/RingGauge.qml \
    qml/Gauges/qmldir \
    qml/PrimaryIndicator.qml \
    qml/SecondaryIndicator.qml \
    qml/Theme/Colors.qml \
    qml/Theme/Theme.qml \
    qml/Theme/qmldir \
    qml/main.qml

