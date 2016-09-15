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
    property    string  qicon
    property    string  qbordercolor1
    property    string  qbordercolor2
    property    int     qbordersize
    property    real    qiconopacity
    property    string  qouterbordercolor
    property    int     qouterbordersize
    property    string  qinnerbordercolor
    property    int     qinnerbordersize

    signal qClicked()
    signal qChecked()
    signal qUnchecked()

    width:  qwidth
    height: qheight

    Image {
        id:                 img
        source:             qicon
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - qbordersize
        height:             parent.height - qbordersize
        opacity:            qiconopacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           qradius
                    border.width:     qbordersize
                }
            }
        }
    }

    Button {
        id:           button
        checkable:    true
        anchors.fill: parent

        style: ButtonStyle {
            background: Rectangle {
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
            }
        }

        onHoveredChanged: {

            effect1.start()

        }

        onClicked:        {

            effect.stop()
            effect.start()
            qClicked()

        }

        onCheckedChanged: {

            if(checked === true) {

                qChecked()

            } else {

                qUnchecked()

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
}
