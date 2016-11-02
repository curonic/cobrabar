#include "tooltip.h"
#include "themeparser.h"
#include <QDesktopWidget>

Tooltip::Tooltip() {

    label  = new QLabel;
    label->setAlignment(Qt::AlignCenter);
    layout = new QVBoxLayout;
    layout->setMargin(0);
    layout->addWidget(label);

    this->setLayout(layout);
    this->setFocusPolicy(Qt::NoFocus);
    this->setAttribute(Qt::WA_TransparentForMouseEvents);
    this->setAttribute(Qt::WA_TranslucentBackground);
    this->setWindowFlags(Qt::CustomizeWindowHint       |
                         Qt::WindowTransparentForInput |
                         Qt::Popup |
                         Qt::ToolTip |
                         Qt::WindowDoesNotAcceptFocus);

}

void Tooltip::showm(QString text, int width, int height, QString color, QString background, int radius) {

    QCursor a;
    QDesktopWidget qw;
    QString cu = QString::number(radius);

    QPoint point(a.pos().x(), a.pos().y() + 24);
    this->setStyleSheet("background: "+background+"; border-radius:"+cu+"px; color: "+color+";");

    if(point.x() + width + height > qw.width())

        move(qw.width() - width - height,a.pos().y() + 24);

     else

        move(point);


    this->resize(0, 0); // reset (some objects may have no popup or a popup is empty)

    if(text.length() > 1) {

        show();

        label->setText(text);

        this->resize(width + height, height * 2);
        // weird bug (a typical qt/qml signal carousel by the looks)
        this->resize(width + height, height * 2);

    }
}

