import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Item {

    property    int     qheight
    property    int     qwidth
    property    int     qradius
    property    string  qcolor1
    property    string  qcolor2
    property    string  qbordercolor

    signal qClicked()
    signal qChecked()
    signal qUnchecked()

    width:  qwidth
    height: qheight

    Button {
        id:           button
        checkable:    true
        anchors.fill: parent

        style: ButtonStyle {
            background: Rectangle {
                width:              parent.width
                implicitHeight:     parent.height
                radius:             qradius
                border.color:       "#33000000"
                anchors.centerIn:   parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: qcolor1 }
                    GradientStop { position: 1.0; color: qcolor2 }
                }
            }
        }

        onHoveredChanged: effect1.start()
        onClicked:        { effect.stop(); effect.start(); qClicked() }
        onCheckedChanged: {

            if(checked === true) { qChecked() } else { qUnchecked() }

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
}
