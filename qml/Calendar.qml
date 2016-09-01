import QtQuick 2.5
import QtGraphicalEffects 1.0
import "../components/"

Item {

    property bool adapt:    true

    anchors.fill: parent

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width
        height:             parent.height
        radius:             calendar_radius
        border.color:       calendar_border_color
        border.width:       calendar_border_size
        color:              calendar_background_color
    }

    Image {
        id:                 img
        source:             calendar_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - calendar_border_size
        height:             parent.height - calendar_border_size
        opacity:            calendar_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           calendar_radius
                    border.color:     calendar_border_color
                    border.width:     calendar_border_size
                    color:            "red"
                }
            }
        }
    }

    QCalendar {

        qdate:            calendarDate
        qtime:            calendarTime
        qtextcolor:       calendar_text_color
        qtimefontfamily:  calendar_time_font_family
        qdatefontfamily:  calendar_date_font_family
        anchors.fill:     parent
        anchors.centerIn: parent
    }
}
