#include "config.h"

// Ordre des datas dans le fichier de conf
//
//0-ID
//1-path
//2-nom
//3-artist
//4-duree
//5-album
//6-date d'ajout
//7-genre
//8-nombre de lecture
//9-commentaire
//10-annee
//11-compositeur
//12-classement
//13-derniere lecture

Config::Config()
{
}

void Config::init()
{
    this->_synchroInProgress = false;
    this->_updateUi = false;
    this->_nb_fields = 14;
    this->_metadata.clear();
    this->_dir.setPath(this->_dir.homePath() + "/audiowire");
    this->_filepath = this->_dir.path() + "/audiowire.cfg";
    this->_dir.mkdir(this->_dir.path());
    QFile f(this->_filepath);
    if (!f.open(QIODevice::WriteOnly))
    {
        this->_err.init("Load file error", "Impossible to load configuration file.");
        qDebug() << "Open error";
        this->_err.show();
    }
    f.close();
}

void Config::appendcfg(QList<QString> list)
{
    QString data;
    int x = 1;
    QFile f(this->_filepath);

        if (!f.open(QIODevice::ReadWrite))
        {
            this->_err.init("Load file error", "Impossible to load configuration file.");
            qDebug() << "Open error";
            this->_err.show();
        }
        else
        {
            f.seek(f.size());
            for (QList<QString>::Iterator it = list.begin(); it != list.end(); ++it)
            { 
                data += *it + "\t";
                if (x == this->_nb_fields)
                {
                    data += "\n";
                    x = 0;
                }
                x++;
            }
            //qDebug() << data;
            f.write(data.toStdString().c_str());
            f.close();
        }
}

void Config::readcfg()
{
    QFile f(this->_filepath);
    if (!f.open(QIODevice::ReadOnly))
    {
        qDebug() << "Open Error";
        this->_err.init("Load file error", "Impossible to load configuration file.");
        this->_err.show();
    }
    QTextStream in(&f);
    while(!in.atEnd())
        {
            QString line = in.readLine();
            for(int x = 0; x != this->_nb_fields; x++)
            {
                this->_metadata.push_back(line.section("\t", x, x));
                //qDebug() << line.section("\t", x, x);
            }
            this->_metadata.clear();
            //line contains each track metadata
        }
    f.close();
}

void    Config::launchSynchro(MusicPlayer * player, LibraryHandler * lib)
{
    if (lib->exists())
    {
        this->_UntreatedMusic = this->epurKnownPath(lib->listAllAudioFiles());
        if (!this->_UntreatedMusic.empty())
        {
            this->_synchroInProgress = true;
            this->_synChroIt = this->_UntreatedMusic.begin();
            player->setMedia(*(this->_synChroIt));
            this->_lastId = this->getLastId();
            qDebug() << "Synchronisation en cours...";
        }
    }
    else
        qDebug() << "Invalid path";
}

QString Config::getMetadata(METADATA data, QString & path, MusicPlayer * player)
{
    QString result;

//    player->setMedia(path);

//    if (data == NAME)
//        result = player->getMetaData();
//    qDebug() << "result = " << result;
    return result;
}

QStringList Config::getMetadata(int id)
{
    QStringList list;
    QFile f(this->_filepath);
    static int x = 0;
    if (!f.open(QIODevice::ReadOnly))
    {
        qDebug() << "Open Error";
        this->_err.init("Load file error", "Impossible to load configuration file.");
        this->_err.show();
    }
    QTextStream in(&f);
    while(!in.atEnd())
        {

          QString line = in.readLine();
          if (line.section("\t", 0, 0).toInt() == id)
          {
            for(int x = 0; x != this->_nb_fields; x++)
                {
                //qDebug() << "getmetadata" << line.section("\t", x, x);
                    list.push_back(line.section("\t", x, x));

                }
          }
        }
    x++;
    f.close();
    return list;
}

int Config::getLastId()
{
    QFile f(this->_filepath);
    int id = 0;

    if (!f.open(QIODevice::ReadOnly))
    {
        qDebug() << "Open Error";
        this->_err.init("Load file error", "Impossible to load configuration file.");
        this->_err.show();
    }
    else
    {
        QTextStream in(&f);
        QString line;
        while(!in.atEnd())
            {
            line = in.readLine();
            if (line.section("\t", 0, 0).toInt() >= id)
                id = line.section("\t", 0, 0).toInt();
            }
        f.close();
    }
    return id;
}

bool    Config::pathIsSet(QString str, QStringList list)
{

    for (QStringList::Iterator it = list.begin(); it != list.end(); it++)
    {
        if(str.compare(*it) == 0)
            return true;
    }
    return false;
}

QStringList Config::epurKnownPath(QStringList path)
{
    QStringList list;
    QStringList res;

    QFile f(this->_filepath);

    if (!f.open(QIODevice::ReadOnly))
    {
        qDebug() << "Open Error";
        this->_err.init("Load file error", "Impossible to load configuration file.");
        this->_err.show();
    }
    else
    {
        QTextStream in(&f);
        while(!in.atEnd())
            {
                QString line;
                line = in.readLine();
                list.push_back(line.section("\t", 1, 1));
            }
        for (QStringList::Iterator it = path.begin(); it != path.end(); it++)
        {
            //qDebug() << "it = " << *it;
             if(this->pathIsSet(*it, list) == false)
             {
                //qDebug() << "on push_back";
                res.push_back(*it);
             }
         }
        f.close();
        return res;
    }
    return path;
}

QList<int>  Config::getTrackList()
{
    QFile f(this->_filepath);
    QList<int>  trackList;

    if (!f.open(QIODevice::ReadOnly))
    {
        qDebug() << "Open Error";
        this->_err.init("Load file error", "Impossible to load configuration file.");
        this->_err.show();
    }
    else
    {
        QTextStream in(&f);
        QString line;
        while(!in.atEnd())
        {
            line = in.readLine();
            trackList.push_back(line.section("\t", 0, 0).toInt());
        }
        f.close();
    }
    return trackList;
}

void        Config::pushBackDatas(QStringList & datas)
{
    this->_datas.push_back(QString::number(this->_lastId));
    this->_lastId += 1;
    this->_datas.push_back(*(this->_synChroIt));
//    qDebug() << "datas.size() = " << datas.size();
    if (datas.size() == 6)
    {
        this->_datas += datas;
        for (int i = 0; i != 6; ++i)
            this->_datas.push_back("A Completer");
    }
    else
    {
        for (int i = 0; i != 12; ++i)
            this->_datas.push_back("ERROR");
    }
}

bool        Config::getSynchroInProgress() const
{
    return this->_synchroInProgress;
}

void        Config::setSynchroInProgress(bool value)
{
    this->_synchroInProgress = value;
}

void        Config::synchroDone()
{
    this->_synchroInProgress = false;
    this->appendcfg(this->_datas);
    qDebug() << "synchro terminée";
}

void        Config::nextDataSong(MusicPlayer * player)
{
    if ((this->_synChroIt + 1) != this->_UntreatedMusic.end())
    {
        this->_synChroIt++;
        player->setMedia(*(this->_synChroIt));
    }
    else
    {
        this->_updateUi = true;
        this->synchroDone();
    }
}

bool        Config::getUpdateUi() const
{
    return this->_updateUi;
}

void        Config::setUpdateUi(bool value)
{
    this->_updateUi = value;
}
