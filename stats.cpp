#include "stats.h"

#include <sys/statvfs.h>

#include <QString>
#include <QDir>
#include <QFile>
#include <QDebug>

/*
 *
 * order: <mountpoint, dev, % free, size_in_gb, label>
 *
 */

QStringList Stats::disk_data() {

    /*
     * some system files we need
     */

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

            fs_.append(dl_.split('\n').at(i).split(' ').at(1)); // mount point
            fs_.append(dl_.split('\n').at(i).split(' ').at(0)); // device

            QByteArray m = fs_.at(0).toLatin1();
            const char *c = m.data();
            struct statvfs s;
            float a;
            a = statvfs(c, &s);
            double p;
            p = 100.0 * (double) (s.f_blocks - s.f_bfree) / (double) (s.f_blocks - s.f_bfree + s.f_bavail);
            unsigned long long ds = (unsigned long long) (s.f_blocks) * (unsigned long long) (s.f_bsize);
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
                    fl = fs_.join(",");
                    device_list.append(fl);
                    device_list.append("|");
                }
            }
        }
    }

    QString la(device_list.data());
    QStringList z(la.split('|'));
    z.sort();


    // 1st split is empty if sort(); is applied. (otherwise last one is empty)
    z.removeAt(0);
    return z;

}

int Stats::disk_count() {

    return disk_data().length();

}

