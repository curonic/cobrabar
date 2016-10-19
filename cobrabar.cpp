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
#include "cobrasettings.h"

#include <QTimer>
#include <QTime>
#include <QVBoxLayout>
#include <QProcess>
#include <QQuickItem>
#include <QFileSystemWatcher>
#include <QFileInfo>
#include <QThread>
#include <QDebug>


CobraBar::CobraBar(QWidget *parent) : QWidget(parent) {

    position_    = new QStringList;
    qmlObject_   = new QObject;
    qmlWidget_   = new QWidget;
    qmlView_     = new QQuickView;
    tooltip_     = new Tooltip;
    t            = new ThemeParser;
    fileWatcher_ = new QFileSystemWatcher;

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

    this->setWindowFlags(Qt::CustomizeWindowHint);

    QTimer *time_timer = new QTimer(this);
    time_timer->start(500);

    QTimer *date_timer = new QTimer(this);
    date_timer->start(4000);

    connect(time_timer, SIGNAL(timeout()), this, SLOT(slotTime()));
    connect(date_timer, SIGNAL(timeout()), this, SLOT(slotDate()));
    connect(qmlObject_, SIGNAL(placeLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(qmlObject_, SIGNAL(applicationLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(qmlObject_, SIGNAL(loaderPosition(QString, int, int, int, int)), this, SLOT(slotPosition(QString, int, int, int, int)));
    connect(qmlObject_, SIGNAL(exit()), this, SLOT(slotExit()));
    connect(qmlObject_, SIGNAL(tooltipShow(QString, int, int)), this, SLOT(slotTooltipShow(QString, int, int)));
    connect(qmlObject_, SIGNAL(tooltipClose()), this, SLOT(slotTooltipClose()));

    connect(fileWatcher_, SIGNAL(fileChanged(const QString &)), this, SLOT(slotApplyStyle()));

    slotApplyStyle();
    getApplications();
    getPlaces();

}

void CobraBar::slotTooltipShow(QString tooltip, int tooltip_width, int tooltip_height) {

    tooltip_->showm(tooltip, tooltip_width, tooltip_height);

}

void CobraBar::slotTooltipClose() {

    tooltip_->close();

}

void CobraBar::slotPosition(QString id, int x, int y, int w, int h) {

    QString id_ = id;

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

    qmlObject_->setProperty("calendarDate", QDate::currentDate().toString("dd-MM-yyyy"));

}

void CobraBar::slotTime() {

    qmlObject_->setProperty("calendarTime", QTime::currentTime().toString("hh:mm:ss"));

}

void CobraBar::getApplications() {

    CobraSettings a;

    qmlObject_->setProperty("applicationIcon", a.getIconsDir());

    for(int i = 0; i < a.getApplicationsCount(); i++) {

        qmlObject_->setProperty("applicationEntry", a.getApplicationsList().at(i));

    }
}

void CobraBar::slotExec(QString external_application) {

    QProcess::startDetached(external_application);

}

void CobraBar::getPlaces() {

    CobraSettings a;

    qmlObject_->setProperty("placeIcon", a.getIconsDir());

    for(int i = 0; i < a.getPlacesCount(); i++) {

        qmlObject_->setProperty("placeEntry", a.getPlacesList().at(i));

    }
}

void CobraBar::slotExit() {

    exit(0);

}

void CobraBar::slotApplyStyle() {


    t->setThemeRules(window(), qmlObject_);

    CobraSettings s;
    QFileInfo f(s.getThemeFile());

    if(!f.exists()) {

        thread()->usleep(1);

    } else {

        fileWatcher_->addPath(s.getThemeFile());

    }
}
