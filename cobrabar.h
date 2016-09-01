#ifndef COBRABAR_H
#define COBRABAR_H

#include <QMainWindow>
#include <QObject>
#include <QQuickView>
#include <QQuickItem>

class CobraBar : public QWidget {

    Q_OBJECT

public:
    CobraBar(QWidget *parent = 0);
    ~CobraBar();

private slots:
    void slotTime();
    void slotDate();
    void slotExec(QString external_application);
    void slotPosition(QString id, int x, int y, int w, int h);
    void slotExit();

    void slotResize(int height_changes);
private:
    QObject     *qmlObject_;
    QWidget     *qmlWidget_;
    QQuickView  *qmlView_;

    QStringList *position_;

    void getApplications();
    void getPlaces();
    void getDisks();
    bool extended_height_;

   /* tempy test. will go in different class */ void applyStyle();
};

#endif // COBRABAR_H