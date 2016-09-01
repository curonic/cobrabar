import QtQuick 2.5
import QtQuick.Layouts 1.0
import "../components/"
import "qrc:/js/Theme.js" as Theme
Item {

    anchors.fill:   parent

    Rectangle {
        anchors.fill:   parent
        color:          Theme.BackgroundColor
    }

    Flow {
        anchors.fill:       parent
        spacing:            parent.width / 10
        anchors.topMargin:  spacing
        anchors.leftMargin: spacing / 2

        QPin {
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        parent.width / 2
            qcolor1:        "#00C000"
            qcolor2:        "#006400"
            qbordercolor:   "#006400"
            onQChecked:     {  }
            onQUnchecked:   {  }
        }

        QPin {
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        parent.width / 2
            qcolor1:        "#FF8000"
            qcolor2:        "#C86400"
            qbordercolor:   "#C86400"
            onQChecked:     {  }
            onQUnchecked:   {  }
        }

        QPin {
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        parent.width / 2
            qcolor1:        "#FF0000"
            qcolor2:        "#C80000"
            qbordercolor:   "#C80000"
            onQChecked:     {  }
            onQUnchecked:   {  }
        }
    }
}

