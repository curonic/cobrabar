import QtQuick 2.5
import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    anchors.fill:   parent

    QCalendar {
        qdate:                  calendarDate
        qtime:                  calendarTime
        qtextcolor:             Theme.TextColor
        anchors.fill:           parent
        anchors.centerIn:       parent
    }
}
