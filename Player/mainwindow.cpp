#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    _ui(new Ui::MainWindow),
    _sliderPressed(false),
    _metaDataLoaded(true)
{
    _ui->setupUi(this);
    this->_player = new MusicPlayer();
    this->_playerControl = new PlayerControl();
    this->_library = new LibraryHandler();
    this->_config = new Config();
    this->_tools = new Tools();
    this->_ui->_pauseButton->hide();
    this->init();
    this->_lastTrack = 0;
}


void        MainWindow::init()
{
    // Init des différentes parties de base du lecteur
    this->_player->init();
    this->_player->volumeChanged(this->_ui->_volumeSlider->value());
    this->_playerControl->init();
    this->_config->init();
    this->_library->init();
    this->_songTimer.setInterval(70);
    this->_songTimer.start(70);
    this->_ui->_volumeUp->hide();
    this->_ui->_volumeDown->show();
    this->_ui->_volumeMute->hide();
    this->_ui->_playlistView->setColumnHidden(0, true);
    this->_ui->_playlistView->setColumnHidden(1, true);


    // Connexions des differentes fonctionnalités de bases du lecteur
    connect(this->_ui->_playPauseButton, SIGNAL(released()), this, SLOT(setPlayButton()));
    connect(this->_ui->_pauseButton, SIGNAL(released()), this, SLOT(setPause()));
    connect(this->_ui->_nextTrack, SIGNAL(released()), this, SLOT(setNext()));
    connect(this->_ui->_previousTrack, SIGNAL(released()), this, SLOT(setPrevious()));
    connect(this->_ui->_volumeSlider, SIGNAL(sliderMoved(int)), this, SLOT(volumeChanged(int)));
    connect(this->_ui->_volumeSlider, SIGNAL(valueChanged(int)), this, SLOT(volumeChanged(int)));
//  connect(this->_ui->_trackSlider, SIGNAL(valueChanged(int)), this, SLOT(musicTimeChanged(int)));
    connect(this->_ui->_trackSlider, SIGNAL(sliderPressed()), this, SLOT(setTrackSliderPressed()));
    connect(this->_ui->_trackSlider, SIGNAL(sliderReleased()), this, SLOT(setTrackSliderReleased()));
    connect(&(this->_songTimer), SIGNAL(timeout()), this, SLOT(setCurrentTimeTrack()));
    connect(this->_ui->_playlistsGridView, SIGNAL(doubleClicked(QModelIndex)), this, SLOT(setQlistGridView(QModelIndex)));
    connect(this->_ui->_playlistView, SIGNAL(doubleClicked(QModelIndex)), this, SLOT(setTrack(QModelIndex)));
    connect(this->_ui->_playlistView, SIGNAL(clicked(QModelIndex)), this, SLOT(setLine(QModelIndex)));
    connect(this->_ui->actionExit, SIGNAL(triggered()), this, SLOT(setExit()));
    connect(this->_ui->actionLibrary, SIGNAL(triggered()), this, SLOT(setLibraryOptionClicked()));
    connect(this->_ui->actionAbout_AudioWire, SIGNAL(triggered()), this, SLOT(setActionAbout()));

    this->_config->launchSynchro(this->_player, this->_library);
}

void        MainWindow::setPlayButton()
{
    this->setPlay(false);
}

void        MainWindow::setPlay(bool forcePlay)
{
    if (this->_player->getMediaLoaded() == true)
    {
        if (forcePlay == true)
            this->_player->play(true);
        else
            this->_player->play(false);
        if (this->_player->getIsPlaying() == true)
        {
            this->_ui->_pauseButton->show();
            this->_ui->_playPauseButton->hide();
        }

    }
}

void        MainWindow::setPause()
{
    this->_player->play(false);
    this->_ui->_pauseButton->hide();
    this->_ui->_playPauseButton->show();
}
void        MainWindow::setRowColor(int r)
{
    for (int i = 0; i != this->_ui->_playlistView->columnCount(); i++)
        this->_ui->_playlistView->item(this->_currentTrack, i)->setBackgroundColor(Qt::gray);
    if (r % 2 == 0)
        for (int i = 0; i != this->_ui->_playlistView->columnCount(); i++)
            this->_ui->_playlistView->item(r, i)->setBackgroundColor("#EEEEEE");
    else
        for (int i = 0; i != this->_ui->_playlistView->columnCount(); i++)
            this->_ui->_playlistView->item(r, i)->setBackgroundColor("#FFFFFF");
    this->_lastTrack = r;
}

void        MainWindow::setTrack(QModelIndex index)
{
    QString id = this->_ui->_playlistView->item(index.row(), 0)->text();
    QStringList track = this->_config->getMetadata(id.toInt());
    this->_player->setTrack(track[1]);
    this->_player->setMediaLoaded(true);
    this->setPlay(true);
    this->_library->setcurrentTrackId(id.toInt());
    this->_currentTrack = index.row();
    for (int r = 0; r != this->_ui->_playlistView->rowCount(); r++)
    {
        if (r % 2 == 0)
            for (int i = 0; i != this->_ui->_playlistView->columnCount(); i++)
                this->_ui->_playlistView->item(r, i)->setBackgroundColor("#EEEEEE");
        else
            for (int i = 0; i != this->_ui->_playlistView->columnCount(); i++)
                this->_ui->_playlistView->item(r, i)->setBackgroundColor("#FFFFFF");
    }
    for (int i = 0; i != this->_ui->_playlistView->columnCount(); i++)
        this->_ui->_playlistView->item(this->_currentTrack, i)->setBackgroundColor(Qt::gray);
}

void        MainWindow::setNext()
{
    int r;

    int id = this->_library->getNextTrackId();
    if (id != -1)
    {
        QStringList track = this->_config->getMetadata(id);
        this->_player->setTrack(track[1]);
        this->_player->setMediaLoaded(true);
        this->setPlay(true);
        this->_library->setcurrentTrackId(id);
        r = this->_currentTrack;
        this->_currentTrack = id;
        this->setRowColor(r);
    }
}

void        MainWindow::setPrevious()
{
    int r;

    if (this->_player->getCurrentTrackTime() < 800)
    {
        int id = this->_library->getPrevTrackId();
        if (id != -1)
        {
            QStringList track = this->_config->getMetadata(id);
            this->_player->setTrack(track[1]);
            this->_player->setMediaLoaded(true);
            this->setPlay(true);
            this->_library->setcurrentTrackId(id);
            r = this->_currentTrack;
            this->_currentTrack = id;
            this->setRowColor(r);
        }
    }
    else
    {
        int id = this->_library->getCurrentTrackId();
        if (id != -1)
        {
            QStringList track = this->_config->getMetadata(id);
            this->_player->setTrack(track[1]);
            this->_player->setMediaLoaded(true);
            this->setPlay(true);
            this->_library->setcurrentTrackId(id);
        }
    }
}

void        MainWindow::volumeChanged(int value)
{

    this->_player->volumeChanged(value);
    if (this->_player->getVolume() == 0)
    {
        this->_ui->_volumeDown->hide();
        this->_ui->_volumeUp->hide();
        this->_ui->_volumeMute->show();
    }

    else if (this->_player->getVolume() < 50)
    {
        this->_ui->_volumeDown->show();
        this->_ui->_volumeUp->hide();
        this->_ui->_volumeMute->hide();
    }
    else if (this->_player->getVolume() >= 50)
    {
        this->_ui->_volumeDown->hide();
        this->_ui->_volumeUp->show();
        this->_ui->_volumeMute->hide();
    }
}

void        MainWindow::musicTimeChanged(int value)
{
    if (this->_sliderPressed == false)
        this->_player->musicTimeChanged(value);
}

void        MainWindow::setTrackSliderPressed()
{
    this->_sliderPressed = true;
}

void        MainWindow::setTrackSliderReleased()
{
    this->_sliderPressed = false;
    this->musicTimeChanged(this->_ui->_trackSlider->value());
}

void        MainWindow::setCurrentTimeTrack()
{
    if (this->_config->getSynchroInProgress() == true)
    {
        this->_metaDataLoaded = false;
    }
    else
        this->_metaDataLoaded = true;
    if (this->_player->getIsPlaying() == true)
    {
        this->_ui->_currentTimeTrack->setText(this->_tools->getStrTimeWithMs(this->_player->getCurrentTrackTime()));
        // set le label correspondant au temps total de la chanson en lecture
        this->_ui->_totalTrackTime->setText(this->_tools->getStrTimeWithMs(this->_player->getTotalTrackTime()));
    }
    if (this->_metaDataLoaded == false)
    {
        QStringList datas = this->_player->getMetaData();
        qDebug() << "size = " << datas.size();
        if (datas.size() > 0)
        {
            this->_tools->showQStringList(datas);
            this->_config->pushBackDatas(datas);
            this->_config->nextDataSong(this->_player);
        }
    }
    if (this->_sliderPressed == false)
        this->_ui->_trackSlider->setValue(this->_player->getSliderTrackValue());
    if (this->_library->getPathModified() == true)
    {
        this->_library->setPath();
        this->_library->setPathModified(false);
        this->_config->launchSynchro(this->_player, this->_library);
        this->_tools->clearTableWidget(this->_ui->_playlistView);
        this->_library->setUiLibrary(this->_ui->_playlistView, this->_player, this->_config);
    }
    if (this->_config->getUpdateUi() == true)
    {
        this->_library->setUiLibrary(this->_ui->_playlistView, this->_player, this->_config);
        this->_config->setUpdateUi(false);
    }
}


// Slot pour la QlistGridView des playlists, bibliothèques, etc sur la partie supèrieur gauche du lecteur
void        MainWindow::setQlistGridView(QModelIndex index)
{
    if (index.row() == 1)
    {
        this->_library->show();
    }
}

void        MainWindow::setLine(QModelIndex)
{
    this->_library->setRowSelected(true);
}

void        MainWindow::setLibraryOptionClicked()
{
    this->_library->show();
}

void        MainWindow::setExit()
{
    this->close();
}

void        MainWindow::setActionAbout()
{
    this->_about.show();
}

MainWindow::~MainWindow()
{
    delete _ui;
    delete this->_player;
    delete this->_playerControl;
    delete this->_tools;
    delete this->_library;
}
