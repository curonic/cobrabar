#ifndef STATS_H
#define STATS_H

#include <QString>

/* not for this class, probably.

+ add cd/usb monitor
+ add more detailed disk I/O activity maybe?
+ add filesystem formats

*/

class Stats {

public:
    QStringList getDisksList();
    int         getDisksCount();
};

#endif // STATS_H
