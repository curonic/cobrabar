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
    property color  border_color:            qbordercolor
    property int    border_radius:           qborderradius
    property int    border_width:            qborderwidth
    property string font_family:             qfontfamily
    property bool   icon_grayscale:          qicongrayscale
    property color  text_color:              qcolor
    property string text_alignment:          qtextalign

    // normal
    property color  qbackgroundcolorbottom
    property color  qbackgroundcolortop
    property color  qbordercolor
    property int    qborderradius
    property int    qborderwidth
    property color  qcolor
    property string qfontfamily
    property bool   qicongrayscale
    property string qtextalign

    // hover
    property color  qhbackgroundcolorbottom
    property color  qhbackgroundcolortop
    property color  qhbordercolor
    property int    qhborderradius
    property int    qhborderwidth
    property color  qhcolor
    property string qhfontfamily
    property bool   qhicongrayscale
    property string qhtextalign

    // focus
    property color  qfbackgroundcolorbottom
    property color  qfbackgroundcolortop
    property color  qfbordercolor
    property int    qfborderradius
    property int    qfborderwidth
    property color  qfcolor
    property string qffontfamily
    property bool   qficongrayscale
    property string qftextalign

    signal qClicked()

    function t_alignment(align) {
        var s = border.height * 0.7 * qhasicon
        if(align === "left") {
            return s + s / 2
        }
        if(align === "right") {
            return width - label.width - s / 2
        }
        if(align === "center") {
            return width / 2 - label.width / 2 + s / 2
        }
    }

    onQbackgroundcolorbottomChanged: background_color_bottom = qbackgroundcolorbottom
    onQbackgroundcolortopChanged:    background_color_top    = qbackgroundcolortop
    onQborderradiusChanged:          border_radius           = qborderradius
    onQhborderwidthChanged:          border_width            = qborderwidth
    onQbordercolorChanged:           border_color            = qbordercolor
    onQfontfamilyChanged:            font_family             = qfontfamily
    onQicongrayscaleChanged:         icon_grayscale          = qicongrayscale
    onQcolorChanged:                 text_color              = qcolor
    onQtextalignChanged:             label.anchors.leftMargin = t_alignment(qtextalign)
    Component.onCompleted:           label.anchors.leftMargin = t_alignment(qtextalign)
    onWidthChanged:                  label.anchors.leftMargin = t_alignment(qtextalign)
    onQiconChanged: {

        if(qicon.charAt(qicon.length - 1) == "/") {
            icon.width = 0
            icon.height = 0
            icon.source = ""
        }
    }

    Timer {
        id:          show_tooltip
        interval:    100
        repeat:      false
        running:     false
        onTriggered: tooltipShow(qtooltip, tooltip.width, tooltip.height, tooltip_color, tooltip_background_color, tooltip_border_radius)
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
        hoverEnabled: true
        anchors.fill: parent

        onEntered: {
            background_color_bottom = qhbackgroundcolorbottom
            background_color_top    = qhbackgroundcolortop
            border_color            = qhbordercolor
            border_radius           = qhborderradius
            border_width            = qhborderwidth
            font_family             = qhfontfamily
            icon_grayscale          = qhicongrayscale
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
            border_color            = qbordercolor
            border_radius           = qborderradius
            border_width            = qborderwidth
            font_family             = qfontfamily
            icon_grayscale          = qicongrayscale
            text_color              = qcolor
            text_alignment          = t_alignment(qtextalign)
            label.anchors.leftMargin = t_alignment(qtextalign)
            show_tooltip.stop()
            close_tooltip.start()
        }

        onClicked:        {
            background_color_bottom = qfbackgroundcolorbottom
            background_color_top    = qfbackgroundcolortop
            border_color            = qfbordercolor
            border_radius           = qfborderradius
            border_width            = qfborderwidth
            font_family             = qffontfamily
            icon_grayscale          = qficongrayscale
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
        id:               border
        width:            parent.width
        height:           parent.height
        radius:           border_radius
        anchors.centerIn: parent
        border.width:     border_width
        border.color:     border_color
        gradient: Gradient {
            GradientStop { position: 0; color: background_color_top }
            GradientStop { position: 1; color: background_color_bottom }
        }
    }

    Image {
        id:                 icon
        source:             qicon
        width:              border.height * 0.7 * qhasicon
        height:             border.height * 0.7 * qhasicon
        anchors.left:       parent.left
        anchors.leftMargin: border.height * 0.15
        anchors.top:        parent.top
        anchors.topMargin:  border.height * 0.15
        fillMode:           Image.PreserveAspectFit
        smooth:             true
    }

    Text {
        id:                     label
        text:                   qlabel
        font.pixelSize:         parent.height / 2.3
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
