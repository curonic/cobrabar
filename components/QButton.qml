import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Item {

    property int    qheight
    property int    qwidth
    property int    qradius
    property string qicon
    property string qtooltip
    property color  bcolor0:     "#44ffffff"
    property color  bcolor1:     "#22000000"
    property color  bshadow:     "#000000"

    signal qClicked()
    signal qChecked()
    signal qUnchecked()

    width:  qwidth
    height: qheight

    Button {
        id:           button
        tooltip:      qtooltip
        anchors.fill: parent

        style: ButtonStyle {
            background: Rectangle {
                radius:           qradius
                anchors.fill:     parent
                anchors.centerIn: parent
                color:            bcolor0
                border.color:     bcolor1

                Rectangle {
                    id:               overlay
                    width:            qwidth  - qradius / 2
                    height:           qheight - qradius / 2
                    radius:           qradius
                    anchors.centerIn: parent
                    color:            bcolor1
                }

                Rectangle {
                    id:               gloss
                    width:            overlay.width
                    height:           overlay.height
                    radius:           qradius / 2
                    anchors.centerIn: parent

                    gradient: Gradient {
                        GradientStop { position: 0; color: bcolor0 }
                        GradientStop { position: 1; color: bcolor1 }
                    }
                }

                GaussianBlur {
                    radius:           qheight
                    anchors.fill:     overlay
                    width:            qwidth
                    height:           qheight
                    samples:          qheight
                    source:           img
                    anchors.centerIn: parent
                }

                Image {
                    id:               img
                    source:           qicon
                    width:            overlay.width - qradius * 2
                    height:           overlay.height - qradius * 2
                    visible:          false
                    anchors.centerIn: overlay
                }

                DropShadow {
                    width:            img.width
                    height:           img.height
                    radius:           qradius * 2
                    samples:          qradius * 4
                    color:            bshadow
                    source:           img
                    anchors.centerIn: overlay
                }
            }
        }

        onHoveredChanged: effect1.start()

        onClicked: {
            effect.stop(); effect.start(); qClicked();
        }

        PropertyAnimation {
            id:       effect
            property: "scale"
            target:    button
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
            duration: 500
        }
    }
}
