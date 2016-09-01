import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "qrc:/js/Theme.js" as Theme

Item {

    property    int     qheight
    property    int     qwidth
    property    int     qradius
    property    string  qtext
    property    string  qtooltip

    property color cds: "#33ffffff"
    property color gradient0: "#444"
    property color gradient1: "#111"

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
//                effect.start();
            }
            onExited: {
                cds = "#33ffffff"
                gradient0 = "#444";
                gradient1 = "#111";
            }

            onClicked:        { effect.stop(); effect.start(); qClicked(); }
            anchors.fill: button

        }

        style: ButtonStyle {
            background: Rectangle {
                width:              parent.width
                height:             parent.height
                radius:             qradius
                border.color:       Theme.PlaceBorderColor
                anchors.centerIn:   parent


                gradient: Gradient {
                    GradientStop { position: 0.0; color: gradient0 }
                    GradientStop { position: 1.0; color: gradient1 }
                }
            }
        }

        Label {
            anchors.centerIn:               parent
            anchors.verticalCenterOffset:   1
            anchors.horizontalCenterOffset:   1
            color:                          Theme.PlaceTextShadow
            text:                           qtext
            font.pixelSize: parent.width > 0 ? parent.width / 14 : 1
        }

        Label {
            anchors.centerIn:   parent
            color:              Theme.PlaceTextColor
            text:               qtext
            font.pixelSize: parent.width > 0 ? parent.width / 14 : 1
        }

        Rectangle {

            width: 1
            height: parent.width - qradius
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height / 2 - 2
            rotation:                       90

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.NoColor }
                GradientStop { position: 0.5; color: cds }
                GradientStop { position: 1.0; color: Theme.NoColor }
            }
        }

        onCheckedChanged: { if(checked === true) { qChecked() } else { qUnchecked() }}
    }
}
