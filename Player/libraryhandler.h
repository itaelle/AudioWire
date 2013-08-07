#ifndef LIBRARYHANDLER_H
#define LIBRARYHANDLER_H

#include <QDialog>
#include <QDir>
#include <QDebug>
#include <QTableWidget>
#include <QFileInfo>
#include <QStringList>
#include <QString>
#include <QMediaMetaData>
#include <QDirIterator>
#include "dialogbox.h"
#include "musicplayer.h"

class Config;

namespace Ui {
class LibraryHandler;
}

class LibraryHandler : public QDialog
{
    Q_OBJECT

private:
    Ui::LibraryHandler *_ui;
    QDir               *_libDir;
    QStringList        _dirList;
    QStringList        _fileList;
    QString            _currentMusicPath;
    QList<int>         _trackList;

    bool                _validPath;
    bool                _rowSelected;
    unsigned int        _currentTrackId;
    bool                _pathModified;

    void        getFileInFolder();
    void        getFoldersInFolder();
    void        setMusicMetadata(QTableWidget *, MusicPlayer *, QString, int);
    bool        comparePath(QString, QString);
    
public:
    explicit LibraryHandler(QWidget *parent = 0);
    ~LibraryHandler();
    
    void        init();
    void        setPath();
    QString     getPath() const;
    void        setUiLibrary(QTableWidget *, MusicPlayer *, Config *);
    bool        isRowSelected() const;
    void        setRowSelected(bool const);
    void        setcurrentTrackId(unsigned int row);
    int         getCurrentTrackId() const;
    int         getNextTrackId();
    int         getPrevTrackId();
    void        setPathModified(bool);
    bool        getPathModified() const;
    bool        exists();
    QDir const * getQDir() const;
    QStringList listAllAudioFiles();

public slots:

    void        setOkButtonClicked();

};


#endif // LIBRARYHANDLER_H
