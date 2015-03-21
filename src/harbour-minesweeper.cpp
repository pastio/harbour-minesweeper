#include <QtQuick>
#include <sailfishapp.h>


int main(int argc, char *argv[])
{

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    QTranslator translator;
    translator.load("harbour-minesweeper_" + QLocale::system().name(),
                    "/usr/share/harbour-minesweeper/translations");
    app->installTranslator(&translator);

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/harbour-minesweeper.qml"));
    view->show();

    return app->exec();

}

