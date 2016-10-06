QT         += core gui quick widgets xml x11extras quickwidgets

TARGET      = CobraBar

TEMPLATE    = app

SOURCES    += main.cpp          \
              cobrabar.cpp      \
              cobrasettings.cpp \
              themeparser.cpp \
    tooltip.cpp

HEADERS    += cobrabar.h      \
              cobrasettings.h \
              themeparser.h \
    tooltip.h

LIBS       += -lX11

RESOURCES  += resources.qrc

#CONFIG     -= qml_debug declarative_debug debug
CONFIG     += c++14
