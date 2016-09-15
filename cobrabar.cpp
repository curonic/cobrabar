/****************************************************************************
 *                                                                          *
 *                    Copyright (C) 2016  <name of author>                  *
 *                                                                          *
 *   This program is free software: you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by   *
 *   the  Free Software Foundation,  either version 3 of the License,  or   *
 *   (at your option) any later version.                                    *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                           *
 *                                                                          *
 *   You should have received a copy of the GNU General Public License      *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
 *                                                                          *
 ****************************************************************************/


#include "cobrabar.h"
#include "stats.h"
#include "cobrasettings.h"
#include "themeparser.h"

#include <iostream>

#include <QDesktopWidget>
#include <QTimer>
#include <QTime>
#include <QVBoxLayout>
#include <QProcess>
#include <QQuickItem>

CobraBar::CobraBar(QWidget *parent) : QWidget(parent) {

    QDesktopWidget qw;
    QRect mainScreenSize = qw.availableGeometry(qw.primaryScreen());

    position_   = new QStringList;
    qmlObject_  = new QObject;
    qmlWidget_  = new QWidget;
    qmlView_    = new QQuickView;

    qmlView_->setSource(QUrl("qrc:/qml/Main.qml"));
    qmlView_->setColor(QColor(Qt::transparent));

    qmlObject_ = qmlView_->rootObject();
    qmlWidget_ = QWidget::createWindowContainer(qmlView_);

    QVBoxLayout *layout = new QVBoxLayout;
    layout->addWidget(qmlWidget_);
    layout->setMargin(0);
    layout->setSpacing(0);

    this->setAttribute(Qt::WA_TranslucentBackground);
    this->setObjectName("CobraBar");
    this->setFocusPolicy(Qt::NoFocus);
    this->setLayout(layout);
    this->move(mainScreenSize.width() - 200,0);
    this->resize(200,mainScreenSize.height());
    this->setWindowFlags(Qt::CustomizeWindowHint);

    QTimer *time_timer = new QTimer(this);
    time_timer->start(500);

    QTimer *date_timer = new QTimer(this);
    date_timer->start(4000);

    qmlObject_->setProperty("global_width",QString::number(this->width()));

    connect(time_timer, SIGNAL(timeout()), this, SLOT(slotTime()));
    connect(date_timer, SIGNAL(timeout()), this, SLOT(slotDate()));
    connect(qmlObject_, SIGNAL(placeLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(qmlObject_, SIGNAL(applicationLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(qmlObject_, SIGNAL(loaderPosition(QString, int, int, int, int)), this, SLOT(slotPosition(QString, int, int, int, int)));
    connect(qmlObject_, SIGNAL(exit()), this, SLOT(slotExit()));
    connect(qmlObject_, SIGNAL(resize(int)), this, SLOT(slotResize(int)));

    applyStyle();

}

CobraBar::~CobraBar() {

}

void CobraBar::slotResize(int height_changes) {

    if(extended_height_ == false) {

        this->resize(this->width(), this->height() + height_changes);

    }
}

void CobraBar::slotPosition(QString id, int x, int y, int w, int h) {

    QString id_;

    id_ = id;
    id_.remove("qrc:/qml/").remove(".qml")
            .append(",")
            .append(QString::number(x))
            .append(",")
            .append(QString::number(y))
            .append(",")
            .append(QString::number(w))
            .append(",")
            .append(QString::number(h));

    position_->append(id_.toLower());

}

void CobraBar::slotDate() {

    QDate date = QDate::currentDate();
    qmlObject_->setProperty("calendarDate", date.toString("dd-MM-yyyy"));

}

void CobraBar::slotTime() {

    QTime time = QTime::currentTime();
    qmlObject_->setProperty("calendarTime", time.toString("hh:mm:ss"));

}

void CobraBar::getApplications() {

    CobraSettings a;

    qmlObject_->setProperty("applicationIcon", a.getIconsDir());
    qmlObject_->setProperty("applicationHeight", a.getApplicationsHeight(this->width()));

    for(int i = 0; i < a.getApplicationsCount(); i++) {

        qmlObject_->setProperty("applicationEntry", a.getApplicationsList().at(i));

    }
}

void CobraBar::slotExec(QString external_application) {

    QProcess *p = new QProcess;
    p->start(external_application);

}

void CobraBar::getPlaces() {

    CobraSettings a;

    qmlObject_->setProperty("placeHeight", a.getPlacesHeight(this->width()));

    for(int i = 0; i < a.getPlacesCount(); i++) {

        qmlObject_->setProperty("placeEntry", a.getPlacesList().at(i));

    }
}

void CobraBar::getDisks() {

    Stats s;

    for( int i = 0; i < s.getDisksCount(); i++) {

        qmlObject_->setProperty("diskEntry",
                                QString(s.getDisksList().at(i))
                                .append(",")
                                .append(QString::number(i)));

    }

    qmlObject_->setProperty("diskHeight", (this->width() / 6.5) * s.getDisksCount());

}

void CobraBar::slotExit() {

    exit(0);

}

void CobraBar::applyStyle() {

    ThemeParser a;

    for(int i = 0; i < a.getThemeLength(); i++) {

        QString m_ = a.getThemeRules().at(i);
        QStringList n_ = m_.split(": ");

        QString property_;
        QString value_;

        property_ = n_.at(0);
        value_ = n_.at(1);

        QByteArray aa = value_.toLatin1().trimmed();
        const char *c_value_ = aa.data();

        QByteArray ba = property_.toLower().toLatin1().trimmed().replace(" ","");
        const char *c_property_ = ba.data();

        if(property_.toLower().contains("general_width")) {

            QDesktopWidget qw;
            QRect mainScreenSize = qw.availableGeometry(qw.primaryScreen());

            this->resize(QString(c_value_).toInt(),this->height());
            this->move(mainScreenSize.width() - this->width(),0);
            qmlObject_->setProperty("global_width",QString::number(this->width()));

        } else if(property_.toLower().contains("general_alignment") && QString(c_value_) == "left") {

            this->move(0,0);

        } else if(property_.toLower().contains("general_extended_height") && QString(c_value_) == "false") {

            Stats m_;
            CobraSettings n_;

            int disks_height;
            int apps_height;
            int places_height;
            int cal_height;
            int pins_height;
            int sum;

            cal_height    = (this->width() / 4) + (this->width() / 20); // mirroring qml numbers
            disks_height  = (this->width() / 6.5 ) * m_.getDisksCount(); // 6.5 is a guess
            apps_height   = n_.getApplicationsHeight(this->width());
            places_height = n_.getPlacesHeight(this->width());
            pins_height   = this->width() / 8 + (this->width() / 20);
            sum           = disks_height + apps_height + places_height + cal_height + pins_height;

            this->resize(this->width(),sum);

            extended_height_ = false;

        } else {

            qmlObject_->setProperty(c_property_, c_value_);

        }
    }

    getApplications();
    getPlaces();
    getDisks();

}
