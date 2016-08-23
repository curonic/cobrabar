QT         += core gui quick widgets xml x11extras quickwidgets

TARGET      = CobraBar

TEMPLATE    = app

SOURCES    += main.cpp       \
              cobrabar.cpp   \
              stats.cpp      \
              cobrasettings.cpp

HEADERS    += cobrabar.h     \
              stats.h        \
              cobrasettings.h

LIBS       += -lX11

RESOURCES  += resources.qrc

CONFIG     -= qml_debug declarative_debug debug
