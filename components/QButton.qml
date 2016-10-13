import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
Item {

    id: button

    // general
    property string qicon
    property string qtooltip
    property string qlabel
    property int    qhasicon
    property bool   qhaslabel

    // dynamic
    property color  background_color_bottom: qbackgroundcolorbottom
    property color  background_color_top:    qbackgroundcolortop
    property color  border_gradient_bottom:  qbordergradientbottom
    property color  border_gradient_top:     qbordergradienttop
    property int    border_radius:           qborderradius
    property int    border_width:            qborderwidth
    property string font_family:             qfontfamily
    property bool   icon_grayscale:          qicongrayscale
    property color  inner_border_color:      qinnerbordercolor
    property int    inner_border_width:      qinnerborderwidth
    property color  outer_border_color:      qouterbordercolor
    property int    outer_border_width:      qouterborderwidth
    property color  text_color:              qcolor
    property string text_alignment:          qtextalign

    // normal
    property color  qbackgroundcolorbottom
    property color  qbackgroundcolortop
    property color  qbordergradientbottom
    property color  qbordergradienttop
    property int    qborderradius
    property int    qborderwidth
    property color  qcolor
    property string qfontfamily
    property bool   qicongrayscale
    property color  qinnerbordercolor
    property int    qinnerborderwidth
    property color  qouterbordercolor
    property int    qouterborderwidth
    property string qtextalign: "center"

    // hover
    property color  qhbackgroundcolorbottom
    property color  qhbackgroundcolortop
    property color  qhbordergradientbottom
    property color  qhbordergradienttop
    property int    qhborderradius
    property int    qhborderwidth
    property color  qhcolor
    property string qhfontfamily
    property bool   qhicongrayscale
    property color  qhinnerbordercolor
    property int    qhinnerborderwidth
    property color  qhouterbordercolor
    property int    qhouterborderwidth
    property string qhtextalign: "center"

    // focus
    property color  qfbackgroundcolorbottom
    property color  qfbackgroundcolortop
    property color  qfbordergradientbottom
    property color  qfbordergradienttop
    property int    qfborderradius
    property int    qfborderwidth
    property color  qfcolor
    property string qffontfamily
    property bool   qficongrayscale
    property color  qfinnerbordercolor
    property int    qfinnerborderwidth
    property color  qfouterbordercolor
    property int    qfouterborderwidth
    property string qftextalign: "center"

    signal qClicked()


    function t_alignment(align) {
        if(align === "left") {
            return icon.width + icon.width / 2
        }
        if(align === "right") {
            return width - label.width - icon.width / 2
        }
        if(align === "center") {
            return width / 2 - label.width / 2 + icon.width / 2
        }
    }

    onQbackgroundcolorbottomChanged: background_color_bottom = qbackgroundcolorbottom
    onQbackgroundcolortopChanged:    background_color_top    = qbackgroundcolortop
    onQbordergradientbottomChanged:  border_gradient_bottom  = qbordergradientbottom
    onQbordergradienttopChanged:     border_gradient_top     = qbordergradienttop
    onQborderradiusChanged:          border_radius           = qborderradius
    onQhborderwidthChanged:          border_width            = qborderwidth
    onQfontfamilyChanged:            font_family             = qfontfamily
    onQicongrayscaleChanged:         icon_grayscale          = qicongrayscale
    onQinnerbordercolorChanged:      inner_border_color      = qinnerbordercolor
    onQinnerborderwidthChanged:      inner_border_width      = qinnerborderwidth
    onQouterbordercolorChanged:      outer_border_color      = qouterbordercolor
    onQouterborderwidthChanged:      outer_border_width      = qouterborderwidth
    onQcolorChanged:                 text_color              = qcolor

    Component.onCompleted: label.anchors.leftMargin = t_alignment(qtextalign)

    Timer {
        id:          show_tooltip
        interval:    1000
        repeat:      false
        running:     false
        onTriggered: tooltipShow(qtooltip, tooltip.width, tooltip.height)
    }

    Timer {
        id:          close_tooltip
        interval:    1
        repeat:      false
        running:     false
        onTriggered: tooltipClose()
    }

    Text {
        id:                  tooltip
        text:                qtooltip
        font.pixelSize:      14
        height:              14
        visible:             false
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment:   Text.AlignVCenter
        renderType:          Text.NativeRendering
    }

    MouseArea {
        id:           mouse
        hoverEnabled: true
        anchors.fill: parent

        onEntered: {
            background_color_bottom = qhbackgroundcolorbottom
            background_color_top    = qhbackgroundcolortop
            border_gradient_bottom  = qhbordergradientbottom
            border_gradient_top     = qhbordergradienttop
            border_radius           = qhborderradius
            border_width            = qhborderwidth
            font_family             = qhfontfamily
            icon_grayscale          = qhicongrayscale
            inner_border_color      = qhinnerbordercolor
            inner_border_width      = qhinnerborderwidth
            outer_border_color      = qhouterbordercolor
            outer_border_width      = qhouterborderwidth
            text_color              = qhcolor
            text_alignment          = t_alignment(qhtextalign)
            label.anchors.leftMargin = t_alignment(qhtextalign)
            fade_effect.stop()
            fade_effect.start()
            show_tooltip.start()

        }

        onExited: {
            background_color_bottom = qbackgroundcolorbottom
            background_color_top    = qbackgroundcolortop
            border_gradient_bottom  = qbordergradientbottom
            border_gradient_top     = qbordergradienttop
            border_radius           = qborderradius
            border_width            = qborderwidth
            font_family             = qfontfamily
            icon_grayscale          = qicongrayscale
            inner_border_color      = qinnerbordercolor
            inner_border_width      = qinnerborderwidth
            outer_border_color      = qouterbordercolor
            outer_border_width      = qouterborderwidth
            text_color              = qcolor
            text_alignment          = t_alignment(qtextalign)
            label.anchors.leftMargin = t_alignment(qtextalign)
            show_tooltip.stop()
            close_tooltip.start()
        }

        onClicked:        {
            background_color_bottom = qfbackgroundcolorbottom
            background_color_top    = qfbackgroundcolortop
            border_gradient_bottom  = qfbordergradientbottom
            border_gradient_top     = qfbordergradienttop
            border_radius           = qfborderradius
            border_width            = qfborderwidth
            font_family             = qffontfamily
            icon_grayscale          = qficongrayscale
            inner_border_color      = qfinnerbordercolor
            inner_border_width      = qfinnerborderwidth
            outer_border_color      = qfouterbordercolor
            outer_border_width      = qfouterborderwidth
            text_color              = qfcolor
            text_alignment          = t_alignment(qftextalign)

            scale_effect.stop()
            scale_effect.start()
            show_tooltip.stop()
            close_tooltip.start()
            qClicked()
        }
    }

    Rectangle {
        anchors.centerIn: parent
        anchors.fill:     parent
        border.color:     outer_border_color
        border.width:     outer_border_width
        radius:           border_radius
        gradient: Gradient {
            GradientStop { position: 0; color: border_gradient_top }
            GradientStop { position: 1; color: border_gradient_bottom }
        }
    }

    Rectangle {
        id:               overlay
        width:            parent.width  - ( border_width + outer_border_width ) * 2
        height:           parent.height - ( border_width + outer_border_width ) * 2
        radius:           border_radius - outer_border_width
        anchors.centerIn: parent
        border.width:     inner_border_width
        border.color:     inner_border_color
        gradient: Gradient {
            GradientStop { position: 0; color: background_color_top }
            GradientStop { position: 1; color: background_color_bottom }
        }
    }

    Image {
        id:                 icon
        source:             qicon
        width:              overlay.height * 0.8 * qhasicon
        height:             overlay.height * 0.8 * qhasicon
        anchors.left:       parent.left
        anchors.leftMargin: overlay.height * 0.1 + border_width + outer_border_width
        anchors.top:        parent.top
        anchors.topMargin:  overlay.height * 0.1 + border_width + outer_border_width
        fillMode:           Image.PreserveAspectFit
        smooth:             true
    }

    Text {
        id:                     label
        text:                   qlabel
        font.pixelSize:         parent.height / 2.3
        font.bold:              true
        font.family:            font_family
        color:                  text_color
        anchors.leftMargin:     text_alignment
        anchors.left:           parent.left
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment:    Text.AlignHCenter
        verticalAlignment:      Text.AlignVCenter
        renderType:             Text.NativeRendering
    }

    Colorize {
        id:           colorize
        source:       icon
        saturation:   0
        anchors.fill: icon
        visible:      icon_grayscale
    }

    PropertyAnimation {
        id:           scale_effect
        property:     "scale"
        target:       button
        from:         0.8
        to:           1
        duration:     100
    }

    PropertyAnimation {
        id:           fade_effect
        property:     "opacity"
        target:       button
        from:         0.8
        to:           1
        duration:     250
    }
}
