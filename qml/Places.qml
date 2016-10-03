import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill: parent
    signal qPopup(int state, string popup_text)

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width  - general_border_width * 2
        height:             parent.height
        radius:             places_border_radius
        border.color:       places_border_color
        border.width:       places_border_width
        color:              places_background_color
    }

    Image {
        id:                 img
        source:             places_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width  - places_border_width - general_border_width * 2
        height:             parent.height - places_border_width
        opacity:            places_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           places_border_radius
                    border.color:     places_border_color
                    border.width:     places_border_width
                    color:            "red"
                }
            }
        }
    }

    Flow {

        property string zap: placeEntry

        spacing:            parent.width / 80
        anchors.topMargin:  parent.width / 20
        anchors.leftMargin: parent.width / 20
        anchors.fill:       parent
        onZapChanged: {
            Qt.createQmlObject(
            "QButton {
                width:     parent.width - parent.width / 20
                height:    parent.width / 6

                qbackgroundcolorbottom: placebutton_background_gradient_bottom
                qbackgroundcolortop:    placebutton_background_gradient_top
                qbordergradientbottom:  placebutton_border_gradient_bottom
                qbordergradienttop:     placebutton_border_gradient_top
                qborderradius:          placebutton_border_radius
                qborderwidth:           placebutton_border_width
                qcolor:                 placebutton_color
                qfontfamily:            placebutton_font_family
                qicongrayscale:         placebutton_icon_grayscale
                qinnerbordercolor:      placebutton_inner_border_color
                qinnerborderwidth:      placebutton_inner_border_width
                qouterbordercolor:      placebutton_outer_border_color
                qouterborderwidth:      placebutton_outer_border_width
                qtextalign:             placebutton_text_align

                qhbackgroundcolorbottom: placebutton_hover_background_gradient_bottom
                qhbackgroundcolortop:    placebutton_hover_background_gradient_top
                qhbordergradientbottom:  placebutton_hover_border_gradient_bottom
                qhbordergradienttop:     placebutton_hover_border_gradient_top
                qhborderradius:          placebutton_hover_border_radius
                qhborderwidth:           placebutton_hover_border_width
                qhcolor:                 placebutton_hover_color
                qhfontfamily:            placebutton_hover_font_family
                qhicongrayscale:         placebutton_hover_icon_grayscale
                qhinnerbordercolor:      placebutton_hover_inner_border_color
                qhinnerborderwidth:      placebutton_hover_inner_border_width
                qhouterbordercolor:      placebutton_hover_outer_border_color
                qhouterborderwidth:      placebutton_hover_outer_border_width
                qhtextalign:             placebutton_hover_text_align

                qfbackgroundcolorbottom: placebutton_focus_background_gradient_bottom
                qfbackgroundcolortop:    placebutton_focus_background_gradient_top
                qfbordergradientbottom:  placebutton_focus_border_gradient_bottom
                qfbordergradienttop:     placebutton_focus_border_gradient_top
                qfborderradius:          placebutton_focus_border_radius
                qfborderwidth:           placebutton_focus_border_width
                qfcolor:                 placebutton_focus_color
                qffontfamily:            placebutton_focus_font_family
                qficongrayscale:         placebutton_focus_icon_grayscale
                qfinnerbordercolor:      placebutton_focus_inner_border_color
                qfinnerborderwidth:      placebutton_focus_inner_border_width
                qfouterbordercolor:      placebutton_focus_outer_border_color
                qfouterborderwidth:      placebutton_focus_outer_border_width
                qftextalign:             placebutton_text_align

                qhasicon:                1
                qlabel:                  '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                qtooltip:                '"+zap.split(",",4).slice(zap.split(",",3).length)+"'
                qicon:                   'file:/"+placeIcon+zap.split(",",2).slice(zap.split(",",1).length)+"'
                onQClicked:              placeLaunch('xdg-open "+zap.split(",",1)+"')
                }", this, "../components/QButton")
        }
    }
}
