import QtQuick 2.0
import QtGraphicalEffects 1.0

 /* get rid of yet another kiddy javascript stuff and add text-shadow */

Item {

    id: button

    // general
    property string qicon
    property string qtooltip

    // dynamic
    property color background_color_bottom: qbackgroundcolorbottom
    property color background_color_top:    qbackgroundcolortop
    property color border_gradient_bottom:  qbordergradientbottom
    property color border_gradient_top:     qbordergradienttop
    property int   border_radius:           qborderradius
    property int   border_width:            qborderwidth
    property color text_color:              qcolor
    property color text_shadow:             qtextshadow
    property bool  icon_grayscale:          qicongrayscale
    property color inner_border_color:      qinnerbordercolor
    property int   inner_border_width:      qinnerborderwidth
    property color outer_border_color:      qouterbordercolor
    property int   outer_border_width:      qouterborderwidth

    // normal
    property color qbackgroundcolorbottom
    property color qbackgroundcolortop
    property color qbordergradientbottom
    property color qbordergradienttop
    property int   qborderradius
    property int   qborderwidth
    property color qcolor
    property color qtextshadow
    property bool  qicongrayscale
    property color qinnerbordercolor
    property int   qinnerborderwidth
    property color qouterbordercolor
    property int   qouterborderwidth

    // hover
    property color qhbackgroundcolorbottom
    property color qhbackgroundcolortop
    property color qhbordergradientbottom
    property color qhbordergradienttop
    property int   qhborderradius
    property int   qhborderwidth
    property color qhcolor
    property color qhtextshadow
    property bool  qhicongrayscale
    property color qhinnerbordercolor
    property int   qhinnerborderwidth
    property color qhouterbordercolor
    property int   qhouterborderwidth

    // focus
    property color qfbackgroundcolorbottom
    property color qfbackgroundcolortop
    property color qfbordergradientbottom
    property color qfbordergradienttop
    property int   qfborderradius
    property int   qfborderwidth
    property color qfcolor
    property color qftextshadow
    property bool  qficongrayscale
    property color qfinnerbordercolor
    property int   qfinnerborderwidth
    property color qfouterbordercolor
    property int   qfouterborderwidth

    signal qClicked()

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent

        onEntered: {
            background_color_bottom = qhbackgroundcolorbottom
            background_color_top    = qhbackgroundcolortop
            border_gradient_bottom  = qhbordergradientbottom
            border_gradient_top     = qhbordergradienttop
            border_radius           = qhborderradius
            border_width            = qhborderwidth
            icon_grayscale          = qhicongrayscale
            inner_border_color      = qhinnerbordercolor
            inner_border_width      = qhinnerborderwidth
            outer_border_color      = qhouterbordercolor
            outer_border_width      = qhouterborderwidth
            text_color              = qhcolor
            text_shadow             = qhtextshadow

            effect1.stop();
            effect1.start();
        }

        onExited: {
            background_color_bottom = qbackgroundcolorbottom
            background_color_top    = qbackgroundcolortop
            border_gradient_bottom  = qbordergradientbottom
            border_gradient_top     = qbordergradienttop
            border_radius           = qborderradius
            border_width            = qborderwidth
            icon_grayscale          = qicongrayscale
            inner_border_color      = qinnerbordercolor
            inner_border_width      = qinnerborderwidth
            outer_border_color      = qouterbordercolor
            outer_border_width      = qouterborderwidth
            text_color              = qcolor
            text_shadow             = qtextshadow
        }

        onClicked:        {
            background_color_bottom = qfbackgroundcolorbottom
            background_color_top    = qfbackgroundcolortop
            border_gradient_bottom  = qfbordergradientbottom
            border_gradient_top     = qfbordergradienttop
            border_radius           = qfborderradius
            border_width            = qfborderwidth
            icon_grayscale          = qficongrayscale
            inner_border_color      = qfinnerbordercolor
            inner_border_width      = qfinnerborderwidth
            outer_border_color      = qfouterbordercolor
            outer_border_width      = qfouterborderwidth
            text_color              = qfcolor
            text_shadow             = qftextshadow

            effect.stop()
            effect.start()
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
        id:                     icon
        source:                 qicon
        width:                  overlay.height * 0.8
        height:                 overlay.height * 0.8
        anchors.leftMargin:     parent.height - parent.height * 0.8
        anchors.left:           parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text:                         qtooltip
        font.pixelSize:               parent.height / 2.5
        anchors.leftMargin:           icon.width + icon.width / 2 + 1
        anchors.left:                 parent.left
        anchors.verticalCenter:       parent.verticalCenter
        anchors.verticalCenterOffset: 1
        horizontalAlignment:          Text.AlignHCenter
        verticalAlignment:            Text.AlignVCenter
        renderType:                   Text.NativeRendering
        font.bold:                    true
        color:                        text_shadow
    }

    Text {
        text:                   qtooltip
        font.pixelSize:         parent.height / 2.5
        anchors.leftMargin:     icon.width + icon.width / 2
        anchors.left:           parent.left
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment:    Text.AlignHCenter
        verticalAlignment:      Text.AlignVCenter
        renderType:             Text.NativeRendering
        font.bold:              true
        color:                  text_color
    }

    Colorize {
        id:           colorize
        source:       icon
        saturation:   0
        anchors.fill: icon
        visible:      icon_grayscale
    }

    PropertyAnimation {
        id:       effect
        property: "scale"
        target:   button
        from:     0.8
        to:       1
        duration: 100
    }

    PropertyAnimation {
        id:       effect1
        property: "opacity"
        target:   button
        from:     0.8
        to:       1
        duration: 250
    }
}
