#include "libraryhandler.h"
#include "ui_libraryhandler.h"
#include "config.h"

LibraryHandler::LibraryHandler(QWidget *parent) :
    QDialog(parent),
    _ui(new Ui::LibraryHandler),
    _validPath(false),
    _rowSelected(false),
    _currentTrackId(0),
    _pathModified(false)
{
    _ui->setupUi(this);
}

void        LibraryHandler::init()
{
    this->_libDir = new QDir();
    this->setPath();
    QStringList filters;
    filters << "*.mp3" << "*.ogg" << "*.flac" << "*.wma" << "*.riff" << "*.wav";
    this->_libDir->setNameFilters(filters);

    connect(this->_ui->buttonBox, SIGNAL(accepted()), this, SLOT(setOkButtonClicked()));
}

void        LibraryHandler::setPath()
{
    if (this->_ui->_libPathLineEdit->text() != "")
    {
        this->_libDir->setPath(this->_ui->_libPathLineEdit->text());
        if (this->_libDir->exists())
        {
            this->_validPath = true;
        }
        else
        {
            this->_validPath = false;
            qDebug() << "Library path does not exist";
        }
    }
}

void        LibraryHandler::getFileInFolder()
{
    this->_fileList.clear();
    this->_fileList.append(this->_libDir->entryList(QDir::Files));
}

void        LibraryHandler::getFoldersInFolder()
{
    this->_dirList.clear();
    this->_fileList.append(this->_libDir->entryList(QDir::Dirs));
}

void        LibraryHandler::setUiLibrary(QTableWidget * table, MusicPlayer * player, Config * config)
{
    table->setSelectionBehavior(QAbstractItemView::SelectRows);
   // this->getFileInFolder();

    QList<int>::Iterator it;

    int     row = 0;
    this->_trackList = config->getTrackList();
    table->setRowCount(this->_trackList.size());
    for (it = this->_trackList.begin(); it != this->_trackList.end(); it++)
    {
        //this->setMusicMetadata(table, player, *it, row);
        QStringList metadata = config->getMetadata(*it);
        int col = 0;
        for (QStringList::Iterator listIt = metadata.begin(); listIt != metadata.end(); ++listIt)
        {
            QTableWidgetItem *item = new QTableWidgetItem();
            //qDebug() << "listIt = " << *listIt << " row = " << row << " col = " << col;
            item->setText(*listIt);
            table->setItem(row, col, item);
            col++;
        }
        row++;
    }
}

void            LibraryHandler::setMusicMetadata(QTableWidget * table, MusicPlayer * player, QString song, int row)
{
// les meta-datas se chargeront ici des qu'on mettera à jour playlist item view

//        QString fullPath = this->_libDir->path();
//        fullPath += "/";
//        fullPath += (song);
//        player->setTrack(fullPath);
//        QStringList metaList = player->getMetaDataKeys();
//        for (QStringList::Iterator it = metaList.begin(); it != metaList.end(); ++it)
//        {
//            //qDebug() << "data babababab = " << (*it);
//        }

//        //qDebug() << "data = " << fullPath;
}

void            LibraryHandler::setcurrentTrackId(unsigned int row)
{
    this->_currentTrackId = row;
}

QString         LibraryHandler::getPath() const
{
    return this->_libDir->path();
}

bool            LibraryHandler::isRowSelected() const
{
    return this->_rowSelected;
}

void            LibraryHandler::setRowSelected(const bool value)
{
    this->_rowSelected = value;
}

void            LibraryHandler::setOkButtonClicked()
{
    if (!this->comparePath(this->_libDir->path(), this->_ui->_libPathLineEdit->text()))
    {   
        this->_libDir->path() = this->_ui->_libPathLineEdit->text();
        this->_pathModified = true;
    }
}

void            LibraryHandler::setPathModified(bool value)
{
    this->_pathModified = value;
}

bool            LibraryHandler::getPathModified() const
{
    return this->_pathModified;
}

bool            LibraryHandler::comparePath(QString str1, QString str2)
{
    QString::Iterator it = str1.begin();
    QString::Iterator it2 = str2.begin();

    for (;(it != str1.end()) && (it2 != str2.end()); ++it)
    {
        if ((*it) != '/' && (*it) != '\\' && (*it2) != '/' && (*it2) != '\\')
        {
            if ((*it) != (*it2))
               return false;
        }
        ++it2;
    }
    if (it == str1.end() && it2 == str2.end())
        return true;
    return false;
}

QDir const *    LibraryHandler::getQDir() const
{
    return this->_libDir;
}

bool            LibraryHandler::exists()
{
    return this->_libDir->exists();
}

QStringList     LibraryHandler::listAllAudioFiles()
{
    QString parentFolder = this->_libDir->path();
    QStringList result;
    QStringList folderContent;
    QStringList allDirs;
    allDirs << parentFolder;
    QDirIterator directories(parentFolder, QDir::Dirs | QDir::NoSymLinks | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
    while(directories.hasNext())
    {
        directories.next();
        allDirs << directories.filePath();
    }

    // Récupère tous les fichiers audios dans le dossier parent et les sous fichiers
    for (QStringList::Iterator it = allDirs.begin(); it != allDirs.end(); ++it)
    {
        this->_libDir->setPath(*it);
        folderContent.clear();
        folderContent.append(this->_libDir->entryList(QDir::Files));
        qDebug() << "Folder = " << this->_libDir->path();
        for (QStringList::iterator it = folderContent.begin(); it != folderContent.end(); ++it)
        {
            result.push_back(this->_libDir->path() + "/" + (*it));
        }
    }
    this->_libDir->setPath(parentFolder);
    return result;
}

int     LibraryHandler::getCurrentTrackId() const
{
    return this->_currentTrackId;
}

int     LibraryHandler::getPrevTrackId()
{
    for (QList<int>::iterator it = this->_trackList.begin(); it != this->_trackList.end(); ++it)
    {
        if (*it == this->_currentTrackId)
        {
            if (it != this->_trackList.begin())
                return (*(it - 1));
            else
                return *(this->_trackList.end() - 1);
        }
    }
    return -1;
}

int     LibraryHandler::getNextTrackId()
{
    for (QList<int>::iterator it = this->_trackList.begin(); it != this->_trackList.end(); ++it)
    {
        if (*it == this->_currentTrackId)
        {
            if (it + 1 != this->_trackList.end())
                return (*(it + 1));
            else
                return *(this->_trackList.begin());
        }
    }
    return -1;
}

LibraryHandler::~LibraryHandler()
{
    delete this->_ui;
}
