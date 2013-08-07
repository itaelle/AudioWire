#ifndef CONFIG_H_
#define CONFIG_H_

#include <QFile>
#include <QDir>
#include <QList>
#include <QDebug>
#include <QString>
#include <QDir>
#include "musicplayer.h"
#include "libraryhandler.h"
#include "tools.h"
#include "error.h"
#include "data.h"

class Config
{
private:
    QList<QString>  _metadata;
    QStringList     _datas;
    QDir            _dir;
    QString         _filepath;
    int             _nb_fields;
    Tools           _tool;
    Error           _err;

    // Attributs pour la synchro des meta datas (A remettre au propre)
    QStringList     _UntreatedMusic;
    bool            _synchroInProgress;
    QStringList::Iterator _synChroIt;
    int             _lastId;
    bool            _updateUi;

    void appendcfg(QList<QString>);
    void readcfg();
    QStringList epurKnownPath(QStringList);
    bool pathIsSet(QString, QStringList);

public:
    Config();
    void init();

    void launchSynchro(MusicPlayer *, LibraryHandler *);
    int getLastId();
    QStringList getMetadata(int);
    QString getMetadata(METADATA, QString &, MusicPlayer *);
    QList<int> getTrackList();
    void pushBackDatas(QStringList &);

    // fonctions pour la synchro des meta datas (A remettre au propre)
    bool        getSynchroInProgress() const;
    void        setSynchroInProgress(bool);
    void        synchroDone();
    void        nextDataSong(MusicPlayer *);
    bool        getUpdateUi() const;
    void        setUpdateUi(bool);
};

#endif // CONFIG_H
