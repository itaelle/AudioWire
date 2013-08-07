#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTime>
#include <QTimer>
#include <QListView>
#include <QString>
#include "data.h"
#include "musicplayer.h"
#include "playercontrol.h"
#include "tools.h"
#include "libraryhandler.h"
#include "config.h"
#include "about.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);

    void        init();
    ~MainWindow();
    
private:
    Ui::MainWindow * _ui;
    PlayerControl *  _playerControl;
    MusicPlayer *    _player;
    Tools *          _tools;
    LibraryHandler * _library;
    Config *         _config;
    About            _about;

    bool            _sliderPressed;
    bool            _metaDataLoaded;
    QTimer          _songTimer;
    int             _currentTrack;
    int             _lastTrack;
signals:


public slots:
    // slot pour les controles de bases du lecteur
    void setPlay(bool);
    void setPlayButton();
    void setPause();
    void setNext();
    void setPrevious();
    void setTrack(QModelIndex);
    void volumeChanged(int);
    void musicTimeChanged(int);
    void setTrackSliderPressed();
    void setTrackSliderReleased();
    void setCurrentTimeTrack();
    void setQlistGridView(QModelIndex);
    void setLine(QModelIndex);
    void setExit();
    void setLibraryOptionClicked();
    void setActionAbout();
    void setRowColor(int);
};

#endif // MAINWINDOW_H
