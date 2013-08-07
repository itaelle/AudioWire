#include "dialogbox.h"
#include "ui_dialogbox.h"

DialogBox::DialogBox(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogBox)
{
    ui->setupUi(this);
}

DialogBox::~DialogBox()
{
    delete ui;
}

void DialogBox::setTitle(QString title)
{
    this->setWindowTitle(title);
}

void DialogBox::setText(QString text)
{
    ui->text->setText(text);
}

void DialogBox::setButtons(QString b1, QString b2)
{
    ui->pushButton->setText(b1);
    ui->pushButton_2->setText(b2);

    connect(ui->pushButton, SIGNAL(clicked()), SLOT(accept()));
    connect(ui->pushButton_2, SIGNAL(clicked()), SLOT(close()));
}

QString DialogBox::getText()
{
    return ui->text->text();
}

QString DialogBox::getTitle()
{
    return this->windowTitle();
}

