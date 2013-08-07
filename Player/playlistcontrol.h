#ifndef PLAYLISTCONTROL_H
#define PLAYLISTCONTROL_H

#include <QMediaPlaylist>


class PlaylistControl
{
public:
    PlaylistControl();

    void        init();

private:
    QMediaPlaylist      _playlist;

};

#endif // PLAYLISTCONTROL_H
