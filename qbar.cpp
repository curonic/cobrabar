#include "qbar.h"
#include "smartpopup.h"
#include "stats.h"

#include <QDesktopWidget>
#include <QTimer>
#include <QTime>
#include <QDir>
#include <QDirIterator>
#include <QVBoxLayout>
#include <QStandardPaths>
#include <QtXml/QDomDocument>
#include <QFile>
#include <QProcess>
#include <QHBoxLayout>
#include <QSurfaceFormat>
#include <QQuickWidget>
#include <X11/Xlib.h>
#include <QtX11Extras/QX11Info>

QBar::QBar(QWidget *parent) : QWidget(parent) {

    QDesktopWidget qw;
    QRect mainScreenSize = qw.availableGeometry(qw.primaryScreen());

    applicationsWidget_  = new QWidget;
    applicationsView_    = new QQuickView;
    applicationsObject_  = new QObject;
    applicationsView_->setSource(QUrl("qrc:/qml/Applications.qml"));
    applicationsObject_ = applicationsView_->rootObject();
    applicationsWidget_  = QWidget::createWindowContainer(applicationsView_);
    applicationsView_->setColor(QColor(Qt::transparent));

    placesWidget_  = new QWidget;
    placesView_    = new QQuickView;
    placesObject_  = new QObject;
    placesView_->setSource(QUrl("qrc:/qml/Places.qml"));
    placesObject_ = placesView_->rootObject();
    placesWidget_  = QWidget::createWindowContainer(placesView_);
    placesView_->setColor(QColor(Qt::transparent));

    calendarWidget_  = new QWidget;
    calendarView_    = new QQuickView;
    calendarObject_  = new QObject;
    calendarView_->setSource(QUrl("qrc:/qml/Calendar.qml"));
    calendarObject_ = calendarView_->rootObject();
    calendarWidget_  = QWidget::createWindowContainer(calendarView_);
    calendarView_->setColor(QColor(Qt::transparent));

    emptyWidget_  = new QWidget;
    emptyView_    = new QQuickView;
    emptyObject_  = new QObject;
    emptyView_->setSource(QUrl("qrc:/qml/Empty.qml"));
    emptyObject_ = emptyView_->rootObject();
    emptyWidget_  = QWidget::createWindowContainer(emptyView_);
    emptyView_->setColor(QColor(Qt::transparent));

    pinsWidget_  = new QWidget;
    pinsView_    = new QQuickView;
    pinsObject_  = new QObject;
    pinsView_->setSource(QUrl("qrc:/qml/Pins.qml"));
    pinsObject_ = pinsView_->rootObject();
    pinsWidget_  = QWidget::createWindowContainer(pinsView_);
    pinsView_->setColor(QColor(Qt::transparent));

    slideshowWidget_  = new QWidget;
    slideshowView_    = new QQuickView;
    slideshowObject_  = new QObject;
    slideshowView_->setSource(QUrl("qrc:/qml/Slideshow.qml"));
    slideshowObject_ = slideshowView_->rootObject();
    slideshowWidget_  = QWidget::createWindowContainer(slideshowView_);
    slideshowView_->setColor(QColor(Qt::transparent));

    statsWidget_  = new QWidget;
    statsView_    = new QQuickView;
    statsObject_  = new QObject;
    statsView_->setSource(QUrl("qrc:/qml/Stats.qml"));
    statsObject_ = statsView_->rootObject();
    statsWidget_  = QWidget::createWindowContainer(statsView_);
    statsView_->setColor(QColor(Qt::transparent));

    popupW_         = new QWidget;
    popupView_      = new QQuickView;
    popupObject_    = new QObject;
    popupView_->setSource(QUrl("qrc:/qml/Popup.qml"));
    popupObject_ = popupView_->rootObject();
    popupW_  = QWidget::createWindowContainer(popupView_);
    popupView_->setColor(QColor(Qt::transparent));

    popup_ = new SmartPopup;
    popup_->setAttribute(Qt::WA_TranslucentBackground);
    popup_->setFocusPolicy(Qt::ClickFocus);
    popup_->setAutoFillBackground(true);

    auto layout  = new QVBoxLayout;
    auto layout1 = new QHBoxLayout;
    auto layout2 = new QVBoxLayout;
    auto layout3 = new QVBoxLayout;

    popup_->setLayout(layout2);

    this->setWindowFlags(Qt::CustomizeWindowHint);

    this->setAttribute(Qt::WA_TranslucentBackground);
    this->setObjectName("qbar");
    this->autoFillBackground();
    this->setStyleSheet("background: #33ff0000;");
    this->setFocusPolicy(Qt::NoFocus);
    this->setLayout(layout);
    this->move(mainScreenSize.width() - 200,0);
    this->resize(200,mainScreenSize.height());

    configDir = QStandardPaths::standardLocations
            (QStandardPaths::ConfigLocation).at(0);

    qbarConfigDir = QString(QStandardPaths::standardLocations
                            (QStandardPaths::ConfigLocation).at(0))
            .append(QDir::separator())
            .append(objectName());

    qbarSettings = QString(QStandardPaths::standardLocations
                           (QStandardPaths::ConfigLocation).at(0))
            .append(QDir::separator())
            .append(objectName())
            .append(QDir::separator())
            .append("settings.xml");

    QTimer *time_timer = new QTimer(this);
    time_timer->start(500);

    QTimer *time_date = new QTimer(this);
    time_date->start(4000);

    QTimer *time_picture = new QTimer(this);
    time_picture->start(10000);

    layout1->addWidget(calendarWidget_);
    layout1->addWidget(pinsWidget_);

    layout->addLayout(layout1);
    layout->addWidget(applicationsWidget_);
    layout->addWidget(placesWidget_);
    layout->addWidget(statsWidget_);
    layout->addWidget(slideshowWidget_);
    layout->addWidget(emptyWidget_);

    layout->setSpacing(0);
    layout->setMargin(0);

    layout1->addStretch();
    layout1->setSpacing(0);
    layout1->setMargin(0);

    layout2->addWidget(popupW_);
    layout2->setSpacing(0);
    layout2->setMargin(0);

    layout3->addStretch();
    layout3->setSpacing(0);
    layout3->setMargin(0);


    connect(time_timer, SIGNAL(timeout()), this, SLOT(slotTime()));
    connect(time_date, SIGNAL(timeout()), this, SLOT(slotDate()));
    connect(time_picture, SIGNAL(timeout()), this, SLOT(slotPicture()));

    connect(applicationsObject_, SIGNAL(applicationLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(placesObject_, SIGNAL(applicationLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(emptyObject_, SIGNAL(showPopup()), this, SLOT(showPopup()));

    getApplications();
    getPlaces();
    getDiskInfo();
}

QBar::~QBar() {

}

void QBar::slotExec(QString external_application) {

    QProcess *p = new QProcess;
    p->start(external_application);

}

void QBar::resizeEvent(QResizeEvent *event) {

    if(event) {
        resizeApplicationsWidget();
        resizePlacesWidget();
        resizeCalendarWidget();
        resizePinsWidget();
        resizeSlideshowWidget();
        resizeStats();
    }

}
void QBar::showPopup() {

    popup_->placement(slideshowWidget_, this->pos().x(), this->pos().y());

}

void QBar::slotTime() {

    QTime time = QTime::currentTime();
    calendarObject_->setProperty("time_",time.toString("hh:mm:ss"));
    emptyObject_->setProperty("time_",time.toString("hh:mm:ss"));

}

void QBar::slotDate() {

    QDate date = QDate::currentDate();
    calendarObject_->setProperty("date_",date.toString("dd-MM-yyyy"));
    emptyObject_->setProperty("date_",date.toString("dd-MM-yyyy"));

}

void QBar::slotPicture() {

    QDomDocument document;

    QString path(qbarSettings);
    QFile file(path);
    document.setContent(&file);

    if(file.exists()) {

        auto root  = document.firstChildElement();
        auto items = root.elementsByTagName("pictures");
        auto node  = items.at(0);
        auto path  = node.namedItem("path").toElement().text().append(QDir::separator());

        path.replace("~", QString
                     (QStandardPaths::standardLocations
                      (QStandardPaths::HomeLocation).at(0)));

        QDir dir(path);
        QDirIterator dirIter(dir.absolutePath(), QDir::NoDotAndDotDot | QDir::Files);

        QStringList list;

        auto uc = dir.count();
        auto sc = QString::number(uc);
        auto c  = sc.toInt() - 2;

        if(c > 0) { // failsafe. if directory is empty

            for (int i = 0; i < c; i++) {

                auto f = QFile::decodeName(dirIter.next().toUtf8());
                list.append(f);

            }

            slideshowObject_->setProperty("picture_",
                                          QString(list.at(qrand() % c))
                                          .prepend("file:/"));

        }
    }
}

void QBar::getDiskInfo() {

    auto s = new Stats;

    for( int i = 0; i < s->disk_count(); i++) {

        statsObject_->setProperty("data_",
                                  QString(s->disk_data().at(i))
                                  .append(",")
                                  .append(QString::number(i)));

    }
}

void QBar::getApplications() {

    QDomDocument document;
    QString path(qbarSettings);
    QFile file(path);

    applicationsObject_->setProperty("icons_",
                                     QString(QStandardPaths::standardLocations
                                             (QStandardPaths::ConfigLocation).at(0))
                                     .append(QDir::separator())
                                     .append(objectName())
                                     .append(QDir::separator())
                                     .append("icons")
                                     .append(QDir::separator()));
    document.setContent(&file);

    QDomElement  root  = document.firstChildElement();
    QDomNodeList items = root.elementsByTagName("application");

    for( int i = 0; i < items.length(); i++) {

        auto node = items.at(i);
        auto map  = node.attributes();
        auto exec = map.namedItem("exec").toAttr().value();
        auto icon = map.namedItem("icon").toAttr().value();
        auto tool = map.namedItem("tooltip").toAttr().value();

        QString b;

        b.append(exec).append(",").append(icon).append(",").append(tool);

        b.replace("~", QString(QStandardPaths::standardLocations(
                                   QStandardPaths::HomeLocation).at(0)));

        applicationsObject_->setProperty("apps_",b);

    }
}

void QBar::getPlaces() {

    QDomDocument document;
    QString path(qbarSettings);
    QFile file(path);

    document.setContent(&file);

    auto root  = document.firstChildElement();
    auto items = root.elementsByTagName("place");

    for( int i = 0; i < items.length(); i++) {

        auto node = items.at(i);
        auto map  = node.attributes();
        auto path = map.namedItem("path").toAttr().value();
        auto text = map.namedItem("text").toAttr().value();
        auto tool = map.namedItem("tooltip").toAttr().value();

        QString b;
        b.append(path).prepend("xdg-open ")
                .append(",").append(text)
                .append(",").append(tool);

        b.replace("~", QString(QStandardPaths::standardLocations(
                                   QStandardPaths::HomeLocation).at(0)));

        placesObject_->setProperty("places_", b);

    }
}

/*
 * we need qwidgets for every qml
 * a) to get x,y,size for popups
 * b) to split up signals and slots (no more unreadable main.qml with 10's of signals)
 * c) it works, qml alone is not and won't be usable.
*/

void QBar::resizeApplicationsWidget() {

    QDomDocument document;
    QString      path(qbarSettings);
    QFile        file(path);

    document.setContent(&file);

    auto root  = document.firstChildElement();
    auto items = root.elementsByTagName("application");

    auto item_count = items.length();
    auto line_count = item_count / 4;

    if (line_count * 4 == items.length()) {

        applicationsWidget_->setFixedHeight( ( ( this->width() / 5 ) + ( this->width() / 20 ) ) * line_count );

    } else if (line_count * 4 < items.length()) {

        applicationsWidget_->setFixedHeight( ( ( this->width() / 5 ) + ( this->width() / 20 ) ) * ( line_count + 1 ) );

    }
}

void QBar::resizePlacesWidget() {

    QDomDocument document;
    QString      path(qbarSettings);
    QFile        file(path);

    document.setContent(&file);

    auto root  = document.firstChildElement();
    auto items = root.elementsByTagName("place");

    placesWidget_->setFixedHeight( ( (this->width() / 10) + (this->width() / 40) ) * items.length() + this->width() / 40 );

}

void QBar::resizeCalendarWidget() {

    calendarWidget_->setFixedHeight( this->width() / 4 + this->width() / 20 );
    calendarWidget_->setFixedWidth( this->width() - this->width() / 10 );

}

void QBar::resizePinsWidget() {

    pinsWidget_->setFixedHeight( this->width() / 4 + this->width() / 20 );
    pinsWidget_->setFixedWidth( this->width() / 10 );

}

void QBar::resizeSlideshowWidget() {

    slideshowWidget_->setFixedHeight( this->width() * 1.5 );

}

void QBar::resizeStats() {

    auto s = new Stats;

    statsWidget_->setFixedHeight( ( this->width() / 6 ) * s->disk_count() );

}
