import QtQuick 2.5
import QtQuick.Layouts 1.0
import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    anchors.fill:   parent

    Flow {
        anchors.fill:       parent
        spacing:            parent.width / 10
        anchors.topMargin:  spacing
        anchors.leftMargin: spacing / 2

        QPin {
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        parent.width / 2
            qcolor1:        "#55ffffff"
            qcolor2:        "#22ff0000"
            onQClicked:     { exit() }
        }

        QPin {
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        parent.width / 2
            qcolor1:        "#55ffffff"
            qcolor2:        "#33000000"
            onQChecked:      { applications.visible = 0 }
            onQUnchecked:    { applications.visible = 1 }
        }

        QPin {
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        parent.width / 2
            qcolor1:        "#55ffffff"
            qcolor2:        "#33000000"
            onQChecked:      { places.visible = 0; disks.visible = 0 }
            onQUnchecked:    { places.visible = 1; disks.visible = 1 }
        }
    }
}

