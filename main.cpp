#include <QtCore>
#include <QFont>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QQuickView>
#include <QSurfaceFormat>
#include <QVariant>

#ifdef _WIN32
#include <Windows.h>
#endif

#include "canbus.h"

const int QML_ARG = 1;
const int DBC_ARG = 2;
const int SIM_ARG = 3;

int main(int argc, char *argv[])
{
    // allow console output to work on Windows
    #ifdef _WIN32
    if (AttachConsole(ATTACH_PARENT_PROCESS)) {
        FILE *pstdout = stdout;
        FILE *pstderr = stderr;
        freopen_s(&pstdout, "CONOUT$", "w", stdout);
        freopen_s(&pstderr, "CONOUT$", "w", stderr);
    }
    #endif

    // setup the app and parse the args
    QGuiApplication app(argc, argv);
    if (app.arguments().size() < SIM_ARG) {
        std::cout << "Usage: onyx-pi-2 qmldir car.dbc [simulation.dat]" << std::endl;
        return 1;
    }

    // set the default font to be the Gotham font,
    // which is the same used as in Tesla vehicles
    QFont font(QStringLiteral("Gotham"), -1, QFont::Normal, false);
    app.setFont(font);

    // enable anti-aliasing
    QSurfaceFormat format;
    format.setSamples(8);
    QSurfaceFormat::setDefaultFormat(format);

    // create the QML enging and add our "qml source" directory to the module
    // import path (not doing this causes loading failures, if running with qml
    // cli, set QML2_IMPORT_PATH)
    QQmlEngine engine;
    QString qmlroot = app.arguments().at(QML_ARG);
    engine.addImportPath(qmlroot);
    qDebug() << "QML engine import path:";
    for (auto& v : engine.importPathList()) {
        qDebug() << "  " << v;
    }

    // wire up the canbus
    Canbus canbus;
    engine.rootContext()->setContextProperty("canbus", &canbus);

    // create a view into which we'll load our qml app, and set the screen
    // size to HD (but quartered on Windows for more convenient testing)
    QQuickView view (&engine, nullptr);
    view.setColor(QColor("black"));
    view.setTitle("Onyx Pi EIC");
    int width = 1920;
    int height = 1080;
#ifdef _WIN32
    width /= 4;
    height /= 4;
#endif
    view.setWidth(width);
    view.setHeight(height);
    view.setResizeMode(QQuickView::ResizeMode::SizeRootObjectToView);

    QObject::connect(&view, &QQuickView::statusChanged, &app, [&view, &qmlroot](QQuickView::Status status) {
        qDebug() << "QML status:" << status;

        // if the app wasn't able to load, display the error with the error qml file (which, yeah,
        // hopefully doesn't have errors in itself!)
        if (status == QQuickView::Error) {
            QStringList errors;
            for (auto& err : view.errors()) {
                errors << err.toString();
            }
            view.setInitialProperties({
               {"errors", errors}
            });
            view.setSource(QUrl::fromLocalFile(qmlroot + "/Error.qml"));
        }
    });

    qDebug() << "QML app from" << qmlroot;
    view.setSource(QUrl::fromLocalFile(qmlroot + "/App.qml"));
    view.show();

    // setup a file watcher and react to any of the qml files changing by reloading
    // the app qml; note that doing it this way rather than re-creating the engine
    // makes it nicer for development as the main window doesn't bounce around;
    // this could be the basis for an auto-updating app on device, assuming the c++
    // part doesn't change
    QFileSystemWatcher watcher;
    QDirIterator it(qmlroot, QStringList() << "*.qml" << "*.js", QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        watcher.addPath(it.next());
    }
    qDebug() << "QML hot reloading files watched:";
    for (auto& v : watcher.files()) {
        qDebug() << "  " << v;
    }

    QObject::connect(&watcher, &QFileSystemWatcher::fileChanged, &app, [&engine, &view, &watcher, &qmlroot](const QString &path) {

        // some editors (e.g. Qt Creator) actually delete and re-create files on save
        // so without the code below this would only catch the first change
        qDebug() << "File changed:" << path;
        watcher.removePath(path);
        if (QFile::exists(path)) {
            watcher.addPath(path);
        }

        // clear the component cache to make sure this loads fresh qml from disk, and
        // reset the initial properties in case previous load was an error
        engine.clearComponentCache();
        view.setInitialProperties({});
        view.setSource(QUrl::fromLocalFile(qmlroot + "/App.qml"));
    });

    // load the dbc and start reading the canbus
    QString dbcfile = app.arguments().at(DBC_ARG);
    qDebug() << "CAN signals decoding from:" << dbcfile;
    canbus.start(dbcfile);

//    // run a simulation based on previously capture logs, if requested
//    if (app.arguments().size() > SIM_ARG) {
//        QString simfile = app.arguments().at(SIM_ARG);
//        qDebug() << "CAN simulation from:" << simfile;
//        canbus.runSimulation(simfile);
//    }

    return app.exec();
}
