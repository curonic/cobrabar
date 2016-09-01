QT         += core gui quick widgets xml x11extras quickwidgets
TARGET      = QBar
TEMPLATE    = app

SOURCES    += main.cpp        \
              qbar.cpp        \
              smartpopup.cpp  \
              stats.cpp

HEADERS    += qbar.h          \
              smartpopup.h    \
              stats.h

RESOURCES  += resources.qrc

LIBS       += -lX11 -lm

#CONFIG     -= qml_debug debug #testing against system libs
