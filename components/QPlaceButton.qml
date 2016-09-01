import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Item {

    property    int     qheight
    property    int     qwidth
    property    int     qradius
    property    string  qtext
    property    string  qtooltip

    property color cds:         "#33ffffff"
    property color gradient0:   "#444"
    property color gradient1:   "#111"
    property color borderColor: "#44000000"
    property color shadow:      "#333"

    signal qClicked()
    signal qChecked()
    signal qUnchecked()

    width:      qwidth
    height:     qheight

    PropertyAnimation {
        id:                 effect
        property:           "scale"
        target:             button
        from:               0.8
        to:                 1
        duration:           80
    }

    Button {
        id:             button
        tooltip:        qtooltip
        anchors.fill:   parent

        MouseArea {
            hoverEnabled: true
            onEntered: {
                cds = "#aaffffff";
                gradient0 = "#555";
                gradient1 = "#222";
            }

            onExited: {
                cds = "#33ffffff"
                gradient0 = "#444";
                gradient1 = "#111";
            }

            onClicked:        { effect.stop(); effect.start(); qClicked() }
            anchors.fill: button

        }

        style: ButtonStyle {
            background: Rectangle {
                width:              parent.width
                height:             parent.height
                radius:             qradius
                border.color:       borderColor
                anchors.centerIn:   parent

                gradient: Gradient {
                    GradientStop { position: 0.0; color: gradient0 }
                    GradientStop { position: 1.0; color: gradient1 }
                }
            }
        }

        Label {
            anchors.centerIn:               parent
            color:                          shadow
            text:                           qtext
            font.pixelSize:                 parent.width > 0 ? parent.width / 14 : 1
            anchors.verticalCenterOffset:   1
            anchors.horizontalCenterOffset: 1
        }

        Label {
            anchors.centerIn: parent
            color:            "#aaffffff"
            text:             qtext
            font.pixelSize:   parent.width > 0 ? parent.width / 14 : 1
        }

        Rectangle {
            width:                        1
            height:                       parent.width - qradius
            anchors.centerIn:             parent
            rotation:                     90
            anchors.verticalCenterOffset: parent.height / 2 - 2

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 0.5; color: cds }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }

        onCheckedChanged: { if(checked === true) { qChecked() } else { qUnchecked() }}
    }
}