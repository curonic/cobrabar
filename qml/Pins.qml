import QtQuick 2.5
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill:   parent

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width
        height:             parent.height
        radius:             pins_radius
        border.color:       pins_border_color
        border.width:       pins_border_size
        color:              pins_background_color
    }

    Image {
        id:                 img
        source:             pins_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - pins_border_size
        height:             parent.height - pins_border_size
        opacity:            pins_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           pins_radius
                    border.color:     pins_border_color
                    border.width:     pins_border_size
                }
            }
        }
    }

    Flow {
        anchors.fill:       parent
        spacing:            parent.width / 10
        anchors.topMargin:  spacing
        anchors.leftMargin: spacing / 2

        QPin {
            qicon:          pin1_background_image
            qbordercolor:   pin1_border_color
            qiconopacity:   pin1_image_opacity
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        pin1_radius
            qcolor1:        pin1_color1
            qcolor2:        pin1_color2
            qbordersize:    pin1_border_size
            onQClicked:     { exit() }
        }

        QPin {
            qicon:          pin2_background_image
            qbordercolor:   pin2_border_color
            qiconopacity:   pin2_image_opacity
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        pin2_radius
            qcolor1:        pin2_color1
            qcolor2:        pin2_color2
            qbordersize:    pin2_border_size
            onQChecked:     { applications.visible = 0; resize(-applications.height) }
            onQUnchecked:   { applications.visible = 1; resize(+applications.height) }
        }

        QPin {
            qicon:          pin3_background_image
            qbordercolor:   pin3_border_color
            qiconopacity:   pin3_image_opacity
            qwidth:         parent.width - parent.width / 10
            qheight:        parent.width - parent.width / 10
            qradius:        pin3_radius
            qcolor1:        pin3_color1
            qcolor2:        pin3_color2
            qbordersize:    pin3_border_size
            onQChecked:     { places.visible = 0; disks.visible = 0; resize(-places.height-disks.height) }
            onQUnchecked:   { places.visible = 1; disks.visible = 1; resize(places.height+disks.height) }
        }
    }
}

