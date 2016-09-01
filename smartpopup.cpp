#include "smartpopup.h"
#include <QTimer>
#include <X11/Xlib.h>
#include <QtX11Extras/QX11Info>

SmartPopup::SmartPopup(QWidget *parent) : QWidget(parent, Qt::CustomizeWindowHint) {

}

void SmartPopup::focusOutEvent(QFocusEvent *event)
{
    if(event) {
        slotClose();
    }
}

void SmartPopup::slotClose() {
    /* let us click something (like button)
       inside the popup before closing */
    QTimer::singleShot(200, this, SLOT(close()));

}

void SmartPopup::setFlags() {


    Display* display = QX11Info::display();
    Atom state   = XInternAtom(display, "_NET_WM_STATE",              True);
    Atom taskbar = XInternAtom(display, "_NET_WM_STATE_SKIP_TASKBAR", True);

    XEvent event;
    event.xclient.type          = 33;
    event.xclient.message_type  = state;
    event.xclient.display       = display;
    event.xclient.window        = this->winId();
    event.xclient.format        = 32;
    event.xclient.data.l[0]     = 1;
    event.xclient.data.l[1]     = 0l;
    event.xclient.data.l[2]     = taskbar;
    event.xclient.data.l[3]     = 0l;
    event.xclient.data.l[4]     = 0l;
    XSendEvent(display, QX11Info::appRootWindow(), False,
               (SubstructureRedirectMask | SubstructureNotifyMask), &event);
    this->setAttribute(Qt::WA_X11NetWmWindowTypePopupMenu);

}

void SmartPopup::placement(QWidget *pop_to, int parent_x, int parent_y) {



    this->setFixedSize( pop_to->width() * 1.2, pop_to->width() / 4 );

    auto relative_to_parent = pop_to->pos().y();
    auto x_ = parent_x - pop_to->width() * 1.2;
    auto y_ = parent_y + pop_to->height() / 2 - this->height() / 2 + relative_to_parent;

    this->setGeometry(x_,y_,this->height(),this->width());

    this->show();
setFlags();


}
