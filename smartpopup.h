#ifndef SMARTPOPUP_H
#define SMARTPOPUP_H

#include <QWidget>

class SmartPopup : public QWidget {

    Q_OBJECT

public:
    explicit SmartPopup(QWidget *parent = 0);
    void placement(QWidget *pop_to, int parent_x, int parent_y);


protected:
    void focusOutEvent(QFocusEvent * event);

private:
    void setFlags();
private slots:
    void slotClose();
};

#endif // SMARTPOPUP_H
