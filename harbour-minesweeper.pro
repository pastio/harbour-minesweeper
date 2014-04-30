# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-minesweeper

CONFIG += sailfishapp

SOURCES += \
    src/harbour-minesweeper.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    qml/pages/Util.js \
    qml/pages/MineField.qml \
    qml/pages/Mine.qml \
    qml/pages/Counter.qml \
    qml/pages/About.qml \
    qml/pages/License.qml \
    qml/pages/CeCILL.js \
    qml/pages/CeCILL_en.js \
    qml/pages/MainPage.qml \
    qml/harbour-minesweeper.qml \
    rpm/harbour-minesweeper.spec \
    rpm/harbour-minesweeper.yaml \
    harbour-minesweeper.desktop

RESOURCES += \
    ressources.qrc

