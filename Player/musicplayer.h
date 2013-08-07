#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H

#include <QDebug>
#include <QMediaPlayer>
#include <QUrl>
#include <QStringList>
#include <QString>
#include <QMediaMetaData>
#include "data.h"
#include "tools.h"

class MusicPlayer : public QObject
{
    Q_OBJECT

public:
    MusicPlayer();

    void        init();
    void        play(bool);
    void        pause();
    void        next(QString song);
    void        previous(QString song);
    void        volumeChanged(int);
    void        musicTimeChanged(int);
    int         getTotalTrackTime() const;
    int         getCurrentTrackTime() const;
    int         getSliderTrackValue();
    int         getVolume() const;
    bool        getIsPlaying() const;
    bool        getMediaLoaded() const;
    void        setMediaLoaded(bool);
    void        setTrack(QString);
    void        setMedia(QString);
    QStringList getMetaData();

    QStringList getMetaDataKeys();
    QString     retrieveMetadata(QMediaPlayer);

private:
    QMediaPlayer *        _player;
    bool                  _isPlaying;
    bool                  _mediaLoaded;
    Tools                 _tool;
};

#endif // MUSICPLAYER_H
