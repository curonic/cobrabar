import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    property int     qheight
    property int     qwidth
    property int     qradius
    property color   qcolor1
    property color   qcolor2
    property string  qicon
    property color   qbordercolor1
    property color   qbordercolor2
    property int     qbordersize
    property real    qiconopacity
    property color   qouterbordercolor
    property int     qouterbordersize
    property color   qinnerbordercolor
    property int     qinnerbordersize
    property bool    checked

// !!! standard (+ hover & focus) !!!
//    property color  qcolor1
//    property color  qcolor2
//    property color  qbordercolor1
//    property color  qbordercolor2
//    property color  qouterbordercolor
//    property int    qbordersize
//    property int    qouterbordersize
//    property int    qinnerbordersize
//    property color  qinnerbordercolor
//    property int    qradius

    signal qClicked()
    signal qChecked()
    signal qUnchecked()

    width:  qwidth
    height: qheight

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent

        onHoveredChanged: {

            effect1.start()

        }

        onClicked: {

            effect.stop()
            effect.start()
            qClicked()

            if(checked == false) {

                qChecked()
                checked = true

            } else if(checked == true) {

                qUnchecked()
                checked = false
            }
        }
    }

    Rectangle {
        id:           button
        width:              parent.width
        height:             parent.height
        radius:             qradius
        anchors.centerIn:   parent
        border.width:       qouterbordersize
        border.color:       qouterbordercolor
        gradient: Gradient {
            GradientStop { position: 0.0; color: qbordercolor1 }
            GradientStop { position: 1.0; color: qbordercolor2 }
        }
    }

    Rectangle {
        width:              parent.width - qbordersize * 2 - qouterbordersize * 2
        implicitHeight:     parent.height - qbordersize * 2 - qouterbordersize * 2
        radius:             qradius
        anchors.centerIn:   parent
        border.width:       qinnerbordersize
        border.color:       qinnerbordercolor
        gradient: Gradient {
            GradientStop { position: 0.0; color: qcolor1 }
            GradientStop { position: 1.0; color: qcolor2 }
        }
    }

    PropertyAnimation {
        id:                 effect
        property:           "scale"
        target:             button
        from:               0.8
        to:                 1
        duration:           100
    }

    PropertyAnimation {
        id:                 effect1
        property:           "opacity"
        target:             button
        from:               0.5
        to:                 1
        duration:           500
    }
}
