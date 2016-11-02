#ifndef TOOLTIP_H
#define TOOLTIP_H

#include <QWidget>
#include <QVBoxLayout>
#include <QLabel>

class Tooltip : public QWidget {

public:
    Tooltip();
    void showm(QString text, int width, int height, QString color, QString background, int radius);

private:
    QVBoxLayout *layout;
    QLabel      *label;

};

#endif // TOOLTIP_H
