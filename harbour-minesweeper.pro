# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-minesweeper

# Use libsailfishapp
CONFIG += sailfishapp

# C++ sources
SOURCES += \
    src/harbour-minesweeper.cpp

# C++ headers
HEADERS +=

# The .desktop file
desktop.files = $${TARGET}.desktop

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
    rpm/$${TARGET}.spec \
    rpm/$${TARGET}.yaml \
    translations/*.ts \
    translations/*.qm \
    $${TARGET}.desktop \
    qml/pages/LocalStorage.js \
    qml/pages/Highscores.qml

RESOURCES += \
    ressources.qrc


# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/$${TARGET}_fr.ts

translations.path = /usr/share/$${TARGET}/translations
translations.files = translations/$${TARGET}_fr.qm

INSTALLS += translations

