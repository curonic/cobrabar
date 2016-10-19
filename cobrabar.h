#ifndef COBRABAR_H
#define COBRABAR_H

#include "tooltip.h"
#include "themeparser.h"

#include <QMainWindow>
#include <QObject>
#include <QQuickView>
#include <QQuickItem>
#include <QFileSystemWatcher>

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
    void slotApplyStyle();
    void slotTooltipShow(QString tooltip, int tooltip_width, int tooltip_height);
    void slotTooltipClose();

private:
    QObject     *qmlObject_;
    QWidget     *qmlWidget_;
    QQuickView  *qmlView_;
    QStringList *position_;
    QFileSystemWatcher *fileWatcher_;
    bool         extended_height_;

    void getApplications();
    void getPlaces();

    Tooltip *tooltip_;
    ThemeParser *t;

};

#endif // COBRABAR_H
