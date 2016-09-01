import QtQuick 2.5
import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    property string time_
    property string date_
    property int timefontsize_

    signal showPopup()

    anchors.fill:   parent

    Rectangle {
        anchors.fill:   parent
        color:          Theme.BackgroundColor
    }

    QCalendar {
        qdate:                  date_
        qtime:                  time_
        qtextcolor:             Theme.TextColor
        anchors.fill:           parent
        anchors.centerIn:       parent

        MouseArea {
            anchors.fill:       parent

            onClicked:          {
                showPopup()
            }
        }
    }
}
