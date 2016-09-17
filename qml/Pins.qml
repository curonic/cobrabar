import QtQuick 2.5
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill:           parent

    Rectangle {
        id:                 container
        anchors.centerIn:   parent
        width:              parent.width / 2
        height:             parent.height
        radius:             pins_border_radius
        border.color:       pins_border_color
        border.width:       pins_border_width
        color:              pins_background_color
    }

    Image {
        id:                 img
        source:             pins_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - pins_border_width
        height:             parent.height - pins_border_width
        opacity:            pins_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           pins_border_radius
                    border.color:     pins_border_color
                    border.width:     pins_border_width
                    color:            "red"
                }
            }
        }
    }

    Row {
        anchors.fill:         container
        spacing:              parent.width / 20
        anchors.centerIn:     parent
        anchors.topMargin:    parent.width / 80
        anchors.bottomMargin: parent.width / 80
        anchors.leftMargin:   spacing

        QPin {
            width:             parent.height
            height:            parent.height
            qicon:             pin1_background_image
            qiconopacity:      pin1_image_opacity
            qradius:           pin1_border_radius
            qcolor1:           pin1_background_gradient_top
            qcolor2:           pin1_background_gradient_bottom
            qbordercolor1:     pin1_border_gradient_top
            qbordercolor2:     pin1_border_gradient_bottom
            qbordersize:       pin1_border_width
            qouterbordercolor: pin1_outer_border_color
            qouterbordersize:  pin1_outer_border_width
            qinnerbordercolor: pin1_inner_border_color
            qinnerbordersize:  pin1_inner_border_width

            onQClicked:     { exit() }
        }

        QPin {
            width:             parent.height
            height:            parent.height
            qicon:             pin2_background_image
            qiconopacity:      pin2_image_opacity
            qradius:           pin2_border_radius
            qcolor1:           pin2_background_gradient_top
            qcolor2:           pin2_background_gradient_bottom
            qbordercolor1:     pin2_border_gradient_top
            qbordercolor2:     pin2_border_gradient_bottom
            qbordersize:       pin2_border_width
            qouterbordercolor: pin2_outer_border_color
            qouterbordersize:  pin2_outer_border_width
            qinnerbordercolor: pin2_inner_border_color
            qinnerbordersize:  pin2_inner_border_width

            onQChecked:     { applications.visible = 0; resize(-applications.height) }
            onQUnchecked:   { applications.visible = 1; resize(+applications.height) }
        }

        QPin {
            width:             parent.height
            height:            parent.height
            qicon:             pin3_background_image
            qiconopacity:      pin3_image_opacity
            qradius:           pin3_border_radius
            qcolor1:           pin3_background_gradient_top
            qcolor2:           pin3_background_gradient_bottom
            qbordercolor1:     pin3_border_gradient_top
            qbordercolor2:     pin3_border_gradient_bottom
            qbordersize:       pin3_border_width
            qouterbordercolor: pin3_outer_border_color
            qouterbordersize:  pin3_outer_border_width
            qinnerbordercolor: pin3_inner_border_color
            qinnerbordersize:  pin3_inner_border_width

            onQChecked:     { places.visible = 0; disks.visible = 0; resize(-places.height-disks.height) }
            onQUnchecked:   { places.visible = 1; disks.visible = 1; resize(places.height+disks.height) }
        }
    }
}

