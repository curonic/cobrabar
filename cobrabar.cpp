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

#include <QDebug>
#include <QFileInfo>
#include <QFileSystemWatcher>
#include <QProcess>
#include <QQuickItem>
#include <QThread>
#include <QTime>
#include <QTimer>
#include <QVBoxLayout>
#include <QX11Info>

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>

CobraBar::CobraBar(QWidget *parent) : QWidget(parent, Qt::FramelessWindowHint) {

    position_    = new QStringList;
    qmlObject_   = new QObject;
    qmlWidget_   = new QWidget;
    qmlView_     = new QQuickView;
    tooltip_     = new Tooltip;
    themeParser_ = new ThemeParser;
    fileWatcher_ = new QFileSystemWatcher;

    qmlView_->setSource(QUrl("qrc:/qml/Main.qml"));
    qmlView_->setColor(Qt::transparent);

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

    QTimer *time_timer = new QTimer(this);
    time_timer->start(500);

    QTimer *date_timer = new QTimer(this);
    date_timer->start(4000);

    connect(time_timer,   SIGNAL(timeout()), this, SLOT(slotTime()));
    connect(date_timer,   SIGNAL(timeout()), this, SLOT(slotDate()));
    connect(qmlObject_,   SIGNAL(placeLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(qmlObject_,   SIGNAL(applicationLaunch(QString)), this, SLOT(slotExec(QString)));
    connect(qmlObject_,   SIGNAL(exit()), this, SLOT(slotExit()));
    connect(qmlObject_,   SIGNAL(tooltipShow(QString, int, int, QString, QString, int)), this, SLOT(slotTooltipShow(QString, int, int, QString, QString, int)));
    connect(qmlObject_,   SIGNAL(tooltipClose()), this, SLOT(slotTooltipClose()));
    connect(qmlObject_,   SIGNAL(resize(int)), this, SLOT(slotResize(int)));
    connect(fileWatcher_, SIGNAL(fileChanged(const QString &)), this, SLOT(slotApplyStyle()));

    slotApplyStyle();
    getObjects();

    flagGuard();

}

void CobraBar::slotTooltipShow(QString text, int width, int height, QString color, QString background, int radius) {

    tooltip_->showm(text, width, height, color, background, radius);

}

void CobraBar::slotResize(int height_changes) {

    resize(width(), height() + height_changes);

}

void CobraBar::slotTooltipClose() {

    tooltip_->close();

}

void CobraBar::slotDate() {

    qmlObject_->setProperty("calendarDate", QDate::currentDate().toString("dd-MM-yyyy"));

}

void CobraBar::slotTime() {

    qmlObject_->setProperty("calendarTime", QTime::currentTime().toString("hh:mm:ss"));

}

void CobraBar::getObjects() {

    CobraSettings a;

    qmlObject_->setProperty("applicationIcon", a.getIconsDir());
    qmlObject_->setProperty("placeIcon", a.getIconsDir());

    for(int i = 0; i < a.getApplicationsCount(); i++)

        qmlObject_->setProperty("applicationEntry", a.getApplicationsList()[i]);

    for(int i = 0; i < a.getPlacesCount(); i++)

        qmlObject_->setProperty("placeEntry", a.getPlacesList()[i]);

}

void CobraBar::slotExec(QString external_application) {

    QProcess::startDetached(external_application);

}

void CobraBar::slotExit() {

    exit(0);

}

void CobraBar::slotApplyStyle() {

    hide();

    themeParser_->setThemeRules(this->window(), qmlObject_);

    CobraSettings s;
    QFileInfo f(s.getThemeFile());

    if(!f.exists())

        thread()->usleep(10);

     else

        fileWatcher_->addPath(s.getThemeFile());

    flagGuard();
}

void CobraBar::flagGuard() {

    show();

    Display *d = QX11Info::display();

    Atom state = XInternAtom(d, "_NET_WM_STATE",              1);
    Atom below = XInternAtom(d, "_NET_WM_STATE_BELOW",        1);
    Atom tbar  = XInternAtom(d, "_NET_WM_STATE_SKIP_TASKBAR", 1);
    Atom pgr   = XInternAtom(d, "_NET_WM_STATE_SKIP_PAGER",   1);

    XEvent e;
    e.xclient.type         = 33;
    e.xclient.message_type = state;
    e.xclient.display      = d;
    e.xclient.window       = winId();
    e.xclient.format       = 32;
    e.xclient.data.l[0]    = 1;
    e.xclient.data.l[1]    = below;
    e.xclient.data.l[2]    = tbar;

    XEvent f;
    f.xclient.type         = 33;
    f.xclient.message_type = state;
    f.xclient.display      = d;
    f.xclient.window       = winId();
    f.xclient.format       = 32;
    f.xclient.data.l[0]    = 1;
    f.xclient.data.l[1]    = pgr;

    XSendEvent(d, QX11Info::appRootWindow(), 0, SubstructureRedirectMask, &e);
    XSendEvent(d, QX11Info::appRootWindow(), 0, SubstructureRedirectMask, &f);

    Atom type  = XInternAtom(d, "_NET_WM_WINDOW_TYPE",         1);
    Atom value = XInternAtom(d, "_NET_WM_WINDOW_TYPE_UTILITY", 1);

    XChangeProperty(d, winId(), type, XA_ATOM, 32, PropModeReplace, (uchar*) &value, 1);

}
