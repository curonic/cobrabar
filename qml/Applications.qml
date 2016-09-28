import QtQuick 2.0
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
        width:              parent.width  - applications_border_width - general_border_width * 2
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

    signal qPopup(int state, string popup_text)

    onQPopup: {
        popup.text = popup_text

        if(state === 0)
            pop_holder.visible = true
            popup.visible      = true

        if(state === 1)
            pop_holder.visible = false
            popup.visible      = true
    }

    // Popup, move to Popup.qml someday
    Rectangle {
        id:                       pop_holder
        anchors.top:              parent.top
        anchors.topMargin:        parent.width / 20
        anchors.horizontalCenter: parent.horizontalCenter
        width:                    popup.width + parent.width / 20
        height:                   parent.width / 10;
        color:                    "#00000000"
        radius:                   applicationbutton_border_radius
        visible:                  false

        Text {
            id:               popup
            font.family:      applicationbutton_font_family
            anchors.centerIn: pop_holder
            color:            applicationbutton_color
            font.pixelSize:   parent.height * 0.8
            visible:          false
            font.bold: true
            renderType:       Text.NativeRendering
        }

        DropShadow {
            anchors.fill: popup
            horizontalOffset: 2
            verticalOffset: 2
            radius: 10.0
            samples: 17
            color: "#000"
            source: popup
        }
    }
    // /Popup

    Flow {
        property string zap: applicationEntry

        anchors.leftMargin: parent.width / 20;
        anchors.topMargin:  parent.width / 5;
        anchors.fill:       parent
        spacing:            parent.width / 40;
        anchors.centerIn:   parent
        onZapChanged: {
            Qt.createQmlObject(
                        "QButton {
                width:  parent.width / 3 - parent.width / 40 - parent.width / 120
                height: parent.width / 3 - parent.width / 40 - parent.width / 120

                qbackgroundcolorbottom: applicationbutton_background_gradient_bottom
                qbackgroundcolortop:    applicationbutton_background_gradient_top
                qbordergradientbottom:  applicationbutton_border_gradient_bottom
                qbordergradienttop:     applicationbutton_border_gradient_top
                qborderradius:          applicationbutton_border_radius
                qborderwidth:           applicationbutton_border_width
                qcolor:                 applicationbutton_color
                qfontfamily:            applicationbutton_font_family
                qicongrayscale:         applicationbutton_icon_grayscale
                qinnerbordercolor:      applicationbutton_inner_border_color
                qinnerborderwidth:      applicationbutton_inner_border_width
                qouterbordercolor:      applicationbutton_outer_border_color
                qouterborderwidth:      applicationbutton_outer_border_width
                qtextalign:             applicationbutton_text_align

                qhbackgroundcolorbottom: applicationbutton_hover_background_gradient_bottom
                qhbackgroundcolortop:    applicationbutton_hover_background_gradient_top
                qhbordergradientbottom:  applicationbutton_hover_border_gradient_bottom
                qhbordergradienttop:     applicationbutton_hover_border_gradient_top
                qhborderradius:          applicationbutton_hover_border_radius
                qhborderwidth:           applicationbutton_hover_border_width
                qhcolor:                 applicationbutton_hover_color
                qhfontfamily:            applicationbutton_hover_font_family
                qhicongrayscale:         applicationbutton_hover_icon_grayscale
                qhinnerbordercolor:      applicationbutton_hover_inner_border_color
                qhinnerborderwidth:      applicationbutton_hover_inner_border_width
                qhouterbordercolor:      applicationbutton_hover_outer_border_color
                qhouterborderwidth:      applicationbutton_hover_outer_border_width
                qhtextalign:             applicationbutton_hover_text_align

                qfbackgroundcolorbottom: applicationbutton_focus_background_gradient_bottom
                qfbackgroundcolortop:    applicationbutton_focus_background_gradient_top
                qfbordergradientbottom:  applicationbutton_focus_border_gradient_bottom
                qfbordergradienttop:     applicationbutton_focus_border_gradient_top
                qfborderradius:          applicationbutton_focus_border_radius
                qfborderwidth:           applicationbutton_focus_border_width
                qfcolor:                 applicationbutton_focus_color
                qffontfamily:            applicationbutton_focus_font_family
                qficongrayscale:         applicationbutton_focus_icon_grayscale
                qfinnerbordercolor:      applicationbutton_focus_inner_border_color
                qfinnerborderwidth:      applicationbutton_focus_inner_border_width
                qfouterbordercolor:      applicationbutton_focus_outer_border_color
                qfouterborderwidth:      applicationbutton_focus_outer_border_width
                qftextalign:             applicationbutton_text_align

                qhasicon:   1
                qlabel:     '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                qicon:      'file:/"+applicationIcon+zap.split(",",2).slice(zap.split(",",1).length)+"';
                onQClicked: applicationLaunch('"+zap.split(",",1)+"')
                }", this, "../components/QButton")
        }
    }
}

