#ifndef TOOLTIP_H
#define TOOLTIP_H

#include <QWidget>
#include <QVBoxLayout>
#include <QLabel>

class Tooltip : public QWidget {

public:
    Tooltip();
    void showm(QString tooltip, int tooltip_width, int tooltip_height);

private:
    QVBoxLayout *layout;
    QLabel      *label;

};

#endif // TOOLTIP_H
