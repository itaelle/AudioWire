#include "musicplayer.h"

MusicPlayer::MusicPlayer():
    _isPlaying(false),
    _mediaLoaded(false)
{
}

void        MusicPlayer::init()
{
    this->_player = new QMediaPlayer();
}

void        MusicPlayer::play(bool forcePlay)
{
    if (this->_isPlaying == false || forcePlay == true)
    {
        this->_isPlaying = true;
        this->_player->play();
    }
    else if (this->_isPlaying == true)
    {
        this->pause();
        this->_isPlaying = false;
    }
}

void        MusicPlayer::pause()
{
    this->_player->pause();
}

void        MusicPlayer::volumeChanged(int value)
{
    this->_player->setVolume(value);
}

bool        MusicPlayer::getIsPlaying() const
{
    return this->_isPlaying;
}

void        MusicPlayer::musicTimeChanged(int value)
{
    this->_player->setPosition(this->_player->duration() * value / 100);
}

int        MusicPlayer::getTotalTrackTime() const
{
   return this->_player->duration();
}

int        MusicPlayer::getCurrentTrackTime() const
{
    return this->_player->position();
}

int         MusicPlayer::getSliderTrackValue()
{
    int res;
    res = this->_player->position() * 100;
    res /= this->_player->duration();
    return res;
}

int         MusicPlayer::getVolume() const
{
    return this->_player->volume();
}

 bool        MusicPlayer::getMediaLoaded() const
 {
     return this->_mediaLoaded;
 }

 void       MusicPlayer::setMediaLoaded(bool value)
 {
     this->_mediaLoaded = value;
 }

// QStringList MusicPlayer::getMetadatas(QString & file)
// {
//    QStringList datas;
// }

 void       MusicPlayer::setTrack(QString song)
 {
     this->_player->stop();
     this->_player->setMedia(QUrl::fromLocalFile(song));
 }

 void       MusicPlayer::setMedia(QString media)
 {
     this->_player->setMedia(QUrl::fromLocalFile(media));
 }

 QStringList       MusicPlayer::getMetaDataKeys()
 {
    return this->_player->availableMetaData();
 }

 void       MusicPlayer::next(QString song)
 {
     this->_player->stop();
     this->_player->setMedia(QUrl::fromLocalFile(song));
 }

 void       MusicPlayer::previous(QString song)
 {
     this->_player->stop();
     this->_player->setMedia(QUrl::fromLocalFile(song));
 }

 QString    MusicPlayer::retrieveMetadata(QMediaPlayer player)
 {
     QStringList list;

     list = this->getMetaDataKeys();
     //this->_player->setMedia(QUrl::fromLocalFile(path));
     while (this->_player->isMetaDataAvailable() != true)
        qDebug() << this->_player->isMetaDataAvailable();
     for(QStringList::Iterator it = list.begin(); it != list.end(); it++)
     {

     }
     return this->_player->metaData("TITLE").toString();

 }

 // Set les meta data. Actionné dans le setCurrentTrackTime du mainwindow.cpp
 QStringList    MusicPlayer::getMetaData()
 {
     QStringList result;

     if (this->_player->isMetaDataAvailable() == true)
     {
         QString data;
         data = this->_player->metaData(QMediaMetaData::Title).toString();
         if (!data.isEmpty())
           result.push_back(data);
         else
             result.push_back("Untitled");
         data = this->_player->metaData(QMediaMetaData::AlbumArtist).toString();
         if (!data.isEmpty())
           result.push_back(data);
         else
             result.push_back("Unknown Artist");
         result.push_back(this->_tool.getStrTimeWithMs(this->_player->metaData(QMediaMetaData::Duration).toInt()));
         data = this->_player->metaData(QMediaMetaData::AlbumTitle).toString();
         if (!data.isEmpty())
           result.push_back(data);
         else
             result.push_back("Unknown Album");
         data = this->_player->metaData(QMediaMetaData::Date).toString();
         if (!data.isEmpty())
           result.push_back(data);
         else
             result.push_back("Unknown");
         data = this->_player->metaData(QMediaMetaData::Category).toString();
         if (!data.isEmpty())
           result.push_back(data);
         else
             result.push_back("Unknown Category");
     }
     return result;
 }
