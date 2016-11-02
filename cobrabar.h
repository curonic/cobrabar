#ifndef COBRABAR_H
#define COBRABAR_H

#include "tooltip.h"
#include "themeparser.h"

#include <QFileSystemWatcher>
#include <QMainWindow>
#include <QObject>
#include <QQuickItem>
#include <QQuickView>

class CobraBar : public QWidget {

    Q_OBJECT

public:
    CobraBar(QWidget *parent = 0);

private slots:
    void slotApplyStyle();
    void slotDate();
    void slotExec(QString external_application);
    void slotExit();
    void slotTime();
    void slotTooltipClose();
    void slotTooltipShow(QString text, int width, int height, QString color, QString background, int radius);
    void slotResize(int height_changes);
private:
    QObject                 *qmlObject_;
    QWidget                 *qmlWidget_;
    QQuickView              *qmlView_;
    QStringList             *position_;
    QFileSystemWatcher      *fileWatcher_;
    Tooltip                 *tooltip_;
    ThemeParser             *themeParser_;
    bool                    extended_height_;

    void getObjects();

    void flagGuard();
};

#endif // COBRABAR_H
