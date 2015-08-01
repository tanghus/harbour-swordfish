# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-swordfish

QT += network

DEPLOYMENT_PATH = /usr/share/$${TARGET}

# App version
DEFINES += APP_VERSION=\"\\\"$${VERSION}\\\"\"

# Wordnik API key
include(apikey.pro)

CONFIG += sailfishapp

SOURCES += src/harbour-swordfish.cpp \
    src/settings.cpp \
    src/filedownloader.cpp

HEADERS += \
    src/settings.h \
    src/filedownloader.h

OTHER_FILES += qml/harbour-swordfish.qml \
    qml/pages/FrontPage.qml \
    qml/cover/CoverPage.qml \
    qml/components/WordnikLogo.qml \
    qml/components/Attribution.qml \
    qml/components/Notification.qml \
    qml/pages/Settings.qml \
    qml/pages/About.qml \
    qml/pages/Results.qml \
    qml/components/WordnikMenu.qml \
    js/wordnikapi.js \
    rpm/harbour-swordfish.changes.in \
    rpm/harbour-swordfish.spec \
    rpm/harbour-swordfish.yaml \
    translations/*.ts \
    harbour-swordfish.desktop \
    images/wordnik.png \
    apikey.pro \
    README.md

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/da_DK.ts \
        translations/de_DE.ts \
        translations/fr_FR.ts \
        translations/nl.ts

images.files = images
images.path = $${DEPLOYMENT_PATH}

js.files = js
js.path = $${DEPLOYMENT_PATH}


INSTALLS += images js

