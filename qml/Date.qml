import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill: parent

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width
        height:             parent.height
        radius:             calendar_border_radius
        border.color:       calendar_border_color
        border.width:       calendar_border_width
        color:              calendar_background_color
    }

    Image {
        id:                 img
        source:             calendar_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width  - calendar_border_width
        height:             parent.height - calendar_border_width
        opacity:            calendar_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           calendar_border_radius
                    border.color:     calendar_border_color
                    border.width:     calendar_border_width
                    color:            "red"
                }
            }
        }
    }

    QCalendar {
        qcal:             calendarDate
        qcalcolor:        date_color
        qcalfontfamily:   date_font_family
        anchors.fill:     parent
        anchors.centerIn: parent
    }

}
