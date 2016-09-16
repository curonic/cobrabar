import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    // general
    property int    qheight
    property int    qwidth
    property string qicon
    property string qtooltip

    property bool  hover_state:        qgray
    property color background_color1:  qcolor1
    property color background_color2:  qcolor2
    property int   border_radius:      qradius
    property int   border_width:       qbordersize
    property color border_color1:      qbordercolor1
    property color border_color2:      qbordercolor2
    property color outerborder_color:  qouterbordercolor
    property int   outerborder_width:  qouterbordersize
    property int   qinnerborder_width: qinnerbordersize
    property color qinnerborder_color: qinnerbordercolor

    // normal
    property int    qradius
    property color  qcolor
    property color  qcolor1
    property color  qcolor2
    property int    qbordersize
    property int    qouterbordersize
    property int    qinnerbordersize
    property color  qinnerbordercolor
    property color  qbordercolor1
    property color  qbordercolor2
    property color  qouterbordercolor
    property bool   qgray
    // hover
    property color  qhcolor1
    property color  qhcolor2
    property color  qhbordercolor1
    property color  qhbordercolor2
    property color  qhouterbordercolor
    property int    qhbordersize
    property int    qhouterbordersize
    property int    qhinnerbordersize
    property color  qhinnerbordercolor
    property int    qhradius
    // focus
    property color  qfcolor1
    property color  qfcolor2
    property color  qfbordercolor1
    property color  qfbordercolor2
    property color  qfouterbordercolor
    property int    qfouterbordersize
    property int    qfinnerbordersize
    property color  qfinnerbordercolor
    property int    qfbordersize
    property int    qfradius

    signal qClicked()
    signal qChecked()
    signal qUnchecked()

    width:  qwidth
    height: qheight

    function invert(color) {return Qt.rgba(255 - color.r, 255 - color.g, 255 - color.b, 1)}

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {
            background_color1   = qhcolor1
            background_color2   = qhcolor2
            border_radius       = qhradius
            border_width        = qhbordersize
            border_color1       = qhbordercolor1
            border_color2       = qhbordercolor2
            outerborder_width   = qhouterbordersize
            outerborder_color   = qhouterbordercolor
            qinnerborder_width  = qhinnerbordersize
            qinnerborder_color  = qhinnerbordercolor

            effect1.stop();
            effect1.start();
        }

        onExited: {
            colorize.visible    = qgray
            background_color1   = qcolor1
            background_color2   = qcolor2
            border_radius       = qradius
            border_width        = qbordersize
            border_color1       = qbordercolor1
            border_color2       = qbordercolor2
            outerborder_width   = qouterbordersize
            outerborder_color   = qouterbordercolor
            qinnerborder_width  = qinnerbordersize
            qinnerborder_color  = qinnerbordercolor
        }

        onClicked:        {
            background_color1   = qfcolor1
            background_color2   = qfcolor2
            border_radius       = qfradius
            border_width        = qfbordersize
            border_color1       = qfbordercolor1
            border_color2       = qfbordercolor2
            outerborder_width   = qfouterbordersize
            outerborder_color   = qfouterbordercolor
            qinnerborder_width  = qfinnerbordersize
            qinnerborder_color  = qfinnerbordercolor

            effect.stop()
            effect.start()
            qClicked()
        }
    }

    Rectangle {
        id:           button
        anchors.fill: parent
        width:        parent.height
        height:       parent.height
        clip:         true
        radius:       border_radius
    }

    Rectangle {
        width:            qwidth
        height:           qheight
        radius:           border_radius
        border.width:     outerborder_width
        border.color:     outerborder_color
        anchors.centerIn: parent
        gradient: Gradient {
            GradientStop { position: 0; color: border_color1 }
            GradientStop { position: 1; color: border_color2 }
        }
    }

    Rectangle {
        id:               overlay
        width:            parent.width - border_width * 2 - outerborder_width * 2
        height:           parent.height - border_width * 2 - outerborder_width * 2
        radius:           border_radius - outerborder_width
        anchors.centerIn: parent
        border.width:     qinnerborder_width
        border.color:     qinnerborder_color
        gradient: Gradient {
            GradientStop { position: 0; color: background_color1 }
            GradientStop { position: 1; color: background_color2 }
        }
    }

    Image {
        id:                     img
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
        anchors.leftMargin:           img.width + img.width / 2 + 1
        anchors.left:                 parent.left
        anchors.verticalCenter:       parent.verticalCenter
        anchors.verticalCenterOffset: 1
        horizontalAlignment:          Text.AlignHCenter
        verticalAlignment:            Text.AlignVCenter
        renderType:                   Text.NativeRendering
        font.bold:                    true
        color:                        invert(qcolor)
    }

    Text {
        text:                   qtooltip
        font.pixelSize:         parent.height / 2.5
        anchors.leftMargin:     img.width + img.width / 2
        anchors.left:           parent.left
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment:    Text.AlignHCenter
        verticalAlignment:      Text.AlignVCenter
        renderType:             Text.NativeRendering
        font.bold:              true
        color:                  qcolor
    }

    Colorize {
        id:           colorize
        source:       img
        hue:          0.0
        saturation:   0
        lightness:    0
        anchors.fill: img
        visible:      hover_state
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
        from:     0.5
        to:       1
        duration: 200
    }
}
