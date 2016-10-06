#ifndef SMARTPOPUP_H
#define SMARTPOPUP_H

#include <QWidget>
#include <QVBoxLayout>
#include <QLabel>

class SmartPopup : public QWidget {

public:
    SmartPopup();
    void showm(QString tooltip, int tooltip_width, int tooltip_height);

private:
    QVBoxLayout *layout;
    QLabel      *label;

};

#endif // SMARTPOPUP_H
