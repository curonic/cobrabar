#ifndef STATS_H
#define STATS_H

#include <QString>

/*
rename it to diskstats or something, it's getting too big
for one class.
*/
class Stats {

public:
    QStringList disk_data();
    int         disk_count();
};

#endif // STATS_H
