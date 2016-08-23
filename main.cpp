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

#include <QApplication>
#include <QX11Info>

#include <X11/Xlib.h>


int main(int argc, char *argv[]) {

    QApplication a(argc, argv);
    CobraBar w;
    w.show();

    Display* d = QX11Info::display();

    Atom state = XInternAtom(d, "_NET_WM_STATE",              True);
    Atom below = XInternAtom(d, "_NET_WM_STATE_BELOW",        True);
    Atom tbar  = XInternAtom(d, "_NET_WM_STATE_SKIP_TASKBAR", True);

    XEvent e;
    e.xclient.type         = 33;
    e.xclient.message_type = state;
    e.xclient.display      = d;
    e.xclient.window       = w.winId();
    e.xclient.format       = 32;
    e.xclient.data.l[0]    = 1;
    e.xclient.data.l[1]    = below;
    e.xclient.data.l[2]    = tbar;

    XSendEvent(d, QX11Info::appRootWindow(), False, SubstructureRedirectMask, &e);

    return a.exec();
}
