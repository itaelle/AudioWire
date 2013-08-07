#ifndef ABOUT_H
#define ABOUT_H

#include <QDialog>
#include <QDesktopServices>
#include <QUrl>
#include <QDebug>

namespace Ui {
class About;
}

class About : public QDialog
{
    Q_OBJECT
    
public:
    explicit About(QWidget *parent = 0);
    ~About();
    void openURL();
    
private:
    Ui::About *ui;
    QUrl _url;
};

#endif // ABOUT_H
