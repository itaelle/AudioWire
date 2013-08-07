#include "about.h"
#include "ui_about.h"

About::About(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::About)
{
    ui->setupUi(this);

    connect(ui->_close, SIGNAL(clicked()), SLOT(close()));
}

About::~About()
{
    delete ui;
}

