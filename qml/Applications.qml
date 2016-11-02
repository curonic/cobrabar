import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.0
import "../components/"

Item {

    anchors.fill:           parent
    property int rounded_size: Math.round(parent.width / 4);

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
        width:              parent.width  - applications_border_width
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

        anchors.leftMargin: 4
        anchors.topMargin:  4
        anchors.fill:       parent
        spacing:            4
        anchors.centerIn:   parent
        onZapChanged: {
            Qt.createQmlObject(
                        "QButton {
                width:  parent.width / 4 - 4
                height: rounded_size - 4

                qbackgroundcolorbottom: applicationbutton_background_gradient_bottom
                qbackgroundcolortop:    applicationbutton_background_gradient_top
                qbordercolor:           applicationbutton_border_color
                qborderradius:          applicationbutton_border_radius
                qborderwidth:           applicationbutton_border_width
                qcolor:                 applicationbutton_color
                qfontfamily:            applicationbutton_font_family
                qicongrayscale:         applicationbutton_icon_grayscale
                qtextalign:             applicationbutton_text_align

                qhbackgroundcolorbottom: applicationbutton_hover_background_gradient_bottom
                qhbackgroundcolortop:    applicationbutton_hover_background_gradient_top
                qhbordercolor:           applicationbutton_hover_border_color
                qhborderradius:          applicationbutton_hover_border_radius
                qhborderwidth:           applicationbutton_hover_border_width
                qhcolor:                 applicationbutton_hover_color
                qhfontfamily:            applicationbutton_hover_font_family
                qhicongrayscale:         applicationbutton_hover_icon_grayscale
                qhtextalign:             applicationbutton_hover_text_align

                qfbackgroundcolorbottom: applicationbutton_focus_background_gradient_bottom
                qfbackgroundcolortop:    applicationbutton_focus_background_gradient_top
                qfbordercolor:           applicationbutton_focus_border_color
                qfborderradius:          applicationbutton_focus_border_radius
                qfborderwidth:           applicationbutton_focus_border_width
                qfcolor:                 applicationbutton_focus_color
                qffontfamily:            applicationbutton_focus_font_family
                qficongrayscale:         applicationbutton_focus_icon_grayscale
                qftextalign:             applicationbutton_text_align

                qhasicon:   1
                qtooltip:   '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                qicon:      'file:/"+applicationIcon+zap.split(",",2).slice(zap.split(",",1).length)+"';
                onQClicked: { applicationLaunch('"+zap.split(",",1)+"'); }
                }", this, "../components/QButton")
        }
    }
}

