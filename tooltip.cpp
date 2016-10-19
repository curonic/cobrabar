#include "tooltip.h"
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
    this->setStyleSheet("background: #cc000000; border-radius: 6px; color: #fff;");

}

void Tooltip::showm(QString tooltip, int tooltip_width, int tooltip_height) {

    QCursor a;
    QDesktopWidget qw;
    QPoint point(a.pos().x(), a.pos().y() + 24);


    if(point.x() + tooltip_width + tooltip_height > qw.width()) {

        this->move(qw.width() - tooltip_width - tooltip_height,a.pos().y() + 24);

    } else {

        this->move(point);

    }

    this->resize(0, 0); // reset (some objects may have no popup or a popup is empty)

    if(tooltip.length() > 1) {

        show();

        label->setText(tooltip);

        this->resize(tooltip_width + tooltip_height, tooltip_height * 2);
        // weird bug (a typical qt/qml signal carousel by the looks)
        this->resize(tooltip_width + tooltip_height, tooltip_height * 2);

    }
}

