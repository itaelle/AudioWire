#include "error.h"
#include "ui_error.h"

Error::Error(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Error)
{
    ui->setupUi(this);
}

void Error::init(QString title, QString text)
{
    this->setWindowTitle(title);
    ui->_text->setText(text);

    connect(ui->pushButton, SIGNAL(clicked()), SLOT(close()));
}

Error::~Error()
{
    delete ui;
}
