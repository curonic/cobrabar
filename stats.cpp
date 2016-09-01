/****************************************************************************
 *                                                                          *
 *                    Copyright (C) 2016  <name of author>                  *
 *                                                                          *
 *   This program is free software: you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by   *
 *   the  Free Software Foundation,  either version 3 of the License,  or   *
 *   (at your option) any later version.                                    *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                           *
 *                                                                          *
 *   You should have received a copy of the GNU General Public License      *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
 *                                                                          *
 ****************************************************************************/

/****************************************************************************
 *                                                                          *
 *          returns all hard drives in QStringList format                   *
 *          order: <mountpoint, dev, % free, size_in_gb, label>             *
 *                                                                          *
 ****************************************************************************/


#include "stats.h"

#include <sys/statvfs.h>

#include <QString>
#include <QDir>
#include <QFile>


QStringList Stats::getDisksList() {

    /* some system files we want */

    QString psm_ = "/proc/self/mounts";
    QString ddl_ = "/dev/disk/by-label/";

    QByteArray device_list;
    QFile f_(psm_);

    f_.open(QIODevice::ReadOnly);
    QByteArray dl_(f_.readAll());
    f_.close();

    for(int i = 0; i < dl_.split('\n').length(); i++) {

        QString device = dl_.split('\n').at(i).split(' ').at(0);
        if(device.contains("/dev/sd") | device.contains("/dev/hd")) {

            QStringList fs_;

            fs_.append(dl_.split('\n').at(i).split(' ').at(1));
            fs_.append(dl_.split('\n').at(i).split(' ').at(0));

            QByteArray m = fs_.at(0).toLatin1();
            const char *c = m.data();
            struct statvfs s;
            float a;
            a = statvfs(c, &s);
            double p;
            p = 100.0 * (double) (s.f_blocks - s.f_bfree) / (double) (s.f_blocks - s.f_bfree + s.f_bavail);
            unsigned long long ds = (unsigned long long) (s.f_blocks) * (unsigned long long) (s.f_bsize);
            /*            /     Kb      /      Mb     /     Gb    */
            double q = ds / (float)1024 / (float)1024 / (float)1024;

            fs_.append(QString::number(p, 'f',2));
            fs_.append(QString::number(q, 'f',2));

            QString test2 = fs_.at(1);
            QDir dir(ddl_);
            dir.setFilter(QDir::NoDotAndDotDot);
            QFileInfoList list = dir.entryInfoList();

            for (int j = 0; j < list.size(); ++j) {
                QFileInfo fileInfo = list.at(j);
                QStringList label;
                label.append(fileInfo.fileName());
                label.append(fileInfo.symLinkTarget());
                QString test1 = label.at(1);

                int x = QString::compare(test1, test2);

                if(x == 0) {

                    fs_.append(label.at(0));

                    QString fl;
                    fl = fs_.join(',');
                    device_list.append(fl).append('|');
                }
            }
        }
    }

    QString la(device_list.data());
    QStringList z(la.split('|'));
    z.sort();
    /* 1st split is empty if sort(); is applied. (otherwise last one is empty) */
    z.removeAt(0);
    return z;

}

int Stats::getDisksCount() {

    return getDisksList().length();

}
