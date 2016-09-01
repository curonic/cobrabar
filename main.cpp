#include "qbar.h"
#include <QApplication>
#include <X11/Xlib.h>
#include <QtX11Extras/QX11Info>

int main(int argc, char *argv[]) {

    QApplication a(argc, argv);
    QBar w;
    w.show();

    Display* display = QX11Info::display();

    Atom state = XInternAtom(display,
                             "_NET_WM_STATE", True );
    Atom below = XInternAtom(display,
                             "_NET_WM_STATE_BELOW", True );
    Atom taskbar = XInternAtom(display,
                               "_NET_WM_STATE_SKIP_TASKBAR", True );

    XEvent event;
    event.xclient.type = 33;
    event.xclient.message_type = state;
    event.xclient.display = display;
    event.xclient.window = w.winId();
    event.xclient.format = 32;
    event.xclient.data.l[0] = 1; // turn on
    event.xclient.data.l[1] = below;
    event.xclient.data.l[2] = taskbar;
    event.xclient.data.l[3] = 0l;
    event.xclient.data.l[4] = 0l;
    XSendEvent(display, QX11Info::appRootWindow(), False,
               (SubstructureRedirectMask | SubstructureNotifyMask), &event);

    return a.exec();
}
