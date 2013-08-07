#ifndef PLAYERCONTROL_H
#define PLAYERCONTROL_H

#include <QDebug>
#include <QMainWindow>
#include <QObject>
#include <QMediaPlaylist>
#include "musicplayer.h"


class PlayerControl : public QObject
{
    Q_OBJECT

public:
    PlayerControl();

    void        init();
    void        enableControl(QMainWindow *);
    void        disableControl();
private:


signals:

public slots:
    void setPlay(MusicPlayer *);

};

#endif // PLAYERCONTROL_H
