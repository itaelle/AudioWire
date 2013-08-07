#-------------------------------------------------
#
# Project created by QtCreator 2013-06-25T13:09:42
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

QT += multimedia

TARGET = AudioWire
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    playercontrol.cpp \
    musicplayer.cpp \
    playlistcontrol.cpp \
    tools.cpp \
    libraryhandler.cpp	\
	config.cpp \
    about.cpp \
    dialogbox.cpp   \
    error.cpp

HEADERS  += mainwindow.h \
    playercontrol.h \
    musicplayer.h \
    playlistcontrol.h \
    tools.h \
    libraryhandler.h	\
	config.h \
    about.h \
    dialogbox.h \
    error.h \
    data.h

FORMS    += mainwindow.ui \
    libraryhandler.ui \
    about.ui \
    dialogbox.ui    \
    error.ui

RC_FILE = AudioWire.rc

RESOURCES += \
    data/Ressources.qrc
