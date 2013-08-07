#ifndef TOOLS_H
#define TOOLS_H

#include <QTime>
#include <QString>
#include <QStringList>
#include <QTableWidget>

class Tools
{
public:
    Tools();
    QString     getStrTimeWithMs(int);
    void        clearTableWidget(QTableWidget *);
    void        showQStringList(QStringList);

private:

};

#endif // TOOLS_H
