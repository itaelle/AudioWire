#ifndef DIALOGBOX_H
#define DIALOGBOX_H

#include <QDialog>
namespace Ui {
class DialogBox;
}

class DialogBox : public QDialog
{
    Q_OBJECT
    
public:
    explicit DialogBox(QWidget *parent = 0);
    ~DialogBox();
    void init();
    void setTitle(QString);
    void setText(QString);
    void setButtons(QString, QString);

    QString getTitle();
    QString getText();

    
private:
    Ui::DialogBox *ui;
};

#endif // DIALOGBOX_H
