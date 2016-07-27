TEMPLATE = lib
CONFIG += plugin staticlib
QT += qml quick

ROOT_DIR = ../..

CONFIG(debug, debug|release): DESTDIR = $${ROOT_DIR}/Output/debug
CONFIG(release, debug|release): DESTDIR = $${ROOT_DIR}/Output/release

TARGET  = top_components

#SOURCES += plugin.cpp

#INSTALLS += target qml pluginfiles

RESOURCES += \
    componentsresources.qrc

HEADERS += \
    componentslibrary.h \
    documenthandler.h \
    toptimer.h

SOURCES += \
    documenthandler.cpp \
    toptimer.cpp
