#ifndef COBRABAR_H
#define COBRABAR_H

#include "smartpopup.h"

#include <QMainWindow>
#include <QObject>
#include <QQuickView>
#include <QQuickItem>

class CobraBar : public QWidget {

    Q_OBJECT

public:
    CobraBar(QWidget *parent = 0);

private slots:
    void slotTime();
    void slotDate();
    void slotExec(QString external_application);
    void slotPosition(QString id, int x, int y, int w, int h);
    void slotExit();
    void slotResize(int height_changes);
    void slotApplyStyle();
    void slotTooltipShow(QString tooltip, int tooltip_width, int tooltip_height);
    void slotTooltipClose();

private:
    QObject     *qmlObject_;
    QWidget     *qmlWidget_;
    QQuickView  *qmlView_;
    QStringList *position_;
    bool         extended_height_;

    void getApplications();
    void getPlaces();

    SmartPopup *tooltip_;

};

#endif // COBRABAR_H
