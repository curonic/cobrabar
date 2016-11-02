import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill: parent
//    signal qPopup(int state, string popup_text)
    property int rounded_size: Math.round(parent.width / 6);

    Rectangle {
       anchors.centerIn:   parent
       width:              parent.width
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
        width:              parent.width  - places_border_width
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
                }
            }
        }
    }

    Flow {
        property string zap:          placeEntry

        anchors.leftMargin: 4
        anchors.topMargin:  4
        anchors.fill:       parent
        spacing:            4
        anchors.centerIn:   parent
        onZapChanged: {
            Qt.createQmlObject(
            "QButton {
                width:     parent.width - 4
                height:    rounded_size

                qbackgroundcolorbottom: placebutton_background_gradient_bottom
                qbackgroundcolortop:    placebutton_background_gradient_top
                qbordercolor:           placebutton_border_color
                qborderradius:          placebutton_border_radius
                qborderwidth:           placebutton_border_width
                qcolor:                 placebutton_color
                qfontfamily:            placebutton_font_family
                qicongrayscale:         placebutton_icon_grayscale
                qtextalign:             placebutton_text_align

                qhbackgroundcolorbottom: placebutton_hover_background_gradient_bottom
                qhbackgroundcolortop:    placebutton_hover_background_gradient_top
                qhbordercolor:           placebutton_hover_border_color
                qhborderradius:          placebutton_hover_border_radius
                qhborderwidth:           placebutton_hover_border_width
                qhcolor:                 placebutton_hover_color
                qhfontfamily:            placebutton_hover_font_family
                qhicongrayscale:         placebutton_hover_icon_grayscale
                qhtextalign:             placebutton_hover_text_align

                qfbackgroundcolorbottom: placebutton_focus_background_gradient_bottom
                qfbackgroundcolortop:    placebutton_focus_background_gradient_top
                qfbordercolor:           placebutton_focus_border_color
                qfborderradius:          placebutton_focus_border_radius
                qfborderwidth:           placebutton_focus_border_width
                qfcolor:                 placebutton_focus_color
                qffontfamily:            placebutton_focus_font_family
                qficongrayscale:         placebutton_focus_icon_grayscale
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
