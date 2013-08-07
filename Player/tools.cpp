#include <QDebug>
#include "tools.h"

Tools::Tools()
{
}

QString     Tools::getStrTimeWithMs(int MTime)
{
    QTime   n(0,0,0);
    QTime   time;

    time = n.addMSecs(MTime);

    if (time.hour() == 0)
        return time.toString("mm:ss");
    return time.toString("hh:mm:ss");
}

void        Tools::clearTableWidget(QTableWidget * table)
{
    int i = 0;
    int totalRow = table->rowCount();

    if (totalRow != 0)
    {
       while (i <= totalRow)
        {
           //qDebug() << "boucle, i = " << i << " row = " << totalRow;
           table->removeRow(0);
            ++i;
        }
    }
}

void        Tools::showQStringList(QStringList list)
{
    QStringList::Iterator it = list.begin();
    qDebug() << "********* Showing QStringList *******";
    for (; it != list.end(); ++it)
    {
        qDebug() << *it;
    }
}
