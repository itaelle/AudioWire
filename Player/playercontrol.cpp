#include "playercontrol.h"

PlayerControl::PlayerControl()
{
}

void        PlayerControl::init()
{
}


void        PlayerControl::setPlay(MusicPlayer * musicPlayer)
{
    musicPlayer->play(false);
}

void        PlayerControl::enableControl(QMainWindow *)
{
}

void        PlayerControl::disableControl()
{
}
