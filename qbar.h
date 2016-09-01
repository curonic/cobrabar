#ifndef QBAR_H
#define QBAR_H

#include "smartpopup.h"

#include <QMainWindow>
#include <QQuickView>
#include <QQuickItem>
#include <QObject>

class QBar : public QWidget {

    Q_OBJECT

public:
    QBar(QWidget *parent = 0);
    ~QBar();

protected:
    void resizeEvent(QResizeEvent *event);
private slots:
    void slotExec(QString external_application);
    void slotPicture();
    void slotTime();
    void slotDate();
    void showPopup();

private:
    QWidget     *applicationsWidget_;
    QQuickView  *applicationsView_;
    QObject     *applicationsObject_;

    SmartPopup  *popup_;
    QWidget     *popupW_;
    QQuickView  *popupView_;
    QObject     *popupObject_;

    QWidget     *placesWidget_;
    QQuickView  *placesView_;
    QObject     *placesObject_;

    QWidget     *calendarWidget_;
    QQuickView  *calendarView_;
    QObject     *calendarObject_;

    QWidget     *emptyWidget_;
    QQuickView  *emptyView_;
    QObject     *emptyObject_;

    QWidget     *pinsWidget_;
    QQuickView  *pinsView_;
    QObject     *pinsObject_;

    QWidget     *slideshowWidget_;
    QQuickView  *slideshowView_;
    QObject     *slideshowObject_;

    QWidget     *statsWidget_;
    QQuickView  *statsView_;
    QObject     *statsObject_;

    QString configDir;
    QString qbarConfigDir;
    QString qbarSettings;
    QString qbarIconsDir;

    void getApplications();
    void getPlaces();
    void getDiskInfo();

    void resizeApplicationsWidget();
    void resizePlacesWidget();
    void resizeCalendarWidget();
    void resizePinsWidget();
    void resizeSlideshowWidget();
    void resizeStats();
};

#endif // QBAR_H
