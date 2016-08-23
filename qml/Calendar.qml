import QtQuick 2.5
import "../components/"

Item {

    property color  fontColor:  "#aaffffff"

    anchors.fill:   parent

    QCalendar {
        qdate:                  calendarDate
        qtime:                  calendarTime
        qtextcolor:             fontColor
        anchors.fill:           parent
        anchors.centerIn:       parent
    }
}
