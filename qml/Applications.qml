import QtQuick 2.5
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill:           parent

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width
        height:             parent.height
        radius:             applications_border_radius
        border.color:       applications_border_color
        border.width:       applications_border_width
        color:              applications_background_color
    }

    Image {
        id:                 img
        source:             applications_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - applications_border_width
        height:             parent.height - applications_border_width
        opacity:            applications_image_opacity
        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           applications_border_radius
                    border.color:     applications_border_color
                    border.width:     applications_border_width
                    color:            "red"
                }
            }
        }
    }

    Flow {
        property string zap: applicationEntry

        anchors.leftMargin: parent.width / 25 + 1;
        anchors.topMargin:  parent.width / 25;
        anchors.fill:       parent
        spacing:            parent.width / 20;
        anchors.centerIn:   parent
        onZapChanged: {
            Qt.createQmlObject(
              "QButton {
                qwidth:         parent.width / 2 - parent.width / 25
                qheight:        parent.width / 5

                qgray:              applicationbutton_icon_grayscale
                qcolor:             applicationbutton_color
                qcolor1:            applicationbutton_background_gradient_top
                qcolor2:            applicationbutton_background_gradient_bottom
                qradius:            applicationbutton_border_radius
                qbordersize:        applicationbutton_border_width
                qbordercolor1:      applicationbutton_border_gradient_top
                qbordercolor2:      applicationbutton_border_gradient_bottom
                qouterbordercolor:  applicationbutton_outer_border_color
                qouterbordersize:   applicationbutton_outer_border_width
                qinnerbordersize:   applicationbutton_inner_border_width
                qinnerbordercolor:  applicationbutton_inner_border_color

                qhcolor1:           applicationbutton_hover_background_gradient_top
                qhcolor2:           applicationbutton_hover_background_gradient_bottom
                qhradius:           applicationbutton_hover_border_radius
                qhbordersize:       applicationbutton_hover_border_width
                qhbordercolor1:     applicationbutton_hover_border_gradient_top
                qhbordercolor2:     applicationbutton_hover_border_gradient_bottom
                qhouterbordercolor: applicationbutton_hover_outer_border_color
                qhouterbordersize:  applicationbutton_hover_outer_border_width
                qhinnerbordercolor: applicationbutton_hover_inner_border_color
                qhinnerbordersize:  applicationbutton_hover_inner_border_width

                qfcolor1:           applicationbutton_focus_background_gradient_top
                qfcolor2:           applicationbutton_focus_background_gradient_bottom
                qfradius:           applicationbutton_focus_border_radius
                qfbordersize:       applicationbutton_focus_border_width
                qfbordercolor1:     applicationbutton_focus_border_gradient_top
                qfbordercolor2:     applicationbutton_focus_border_gradient_bottom
                qfouterbordercolor: applicationbutton_focus_outer_border_color
                qfouterbordersize:  applicationbutton_focus_outer_border_width
                qfinnerbordersize:  applicationbutton_focus_inner_border_width
                qfinnerbordercolor: applicationbutton_focus_inner_border_color

                qtooltip:       '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                qicon:          'file:/"+applicationIcon+zap.split(",",2).slice(zap.split(",",1).length)+"';
                onQClicked:     applicationLaunch('"+zap.split(",",1)+"')
                }", this, "../components/QButton")
        }
    }
}

