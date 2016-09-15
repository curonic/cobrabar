import QtQuick 2.5
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill: parent

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width
        height:             parent.height
        radius:             places_border_radius
        border.color:       places_border_color
        border.width:       places_border_width
        color:              places_background_color
    }

    Image {
        id:                 img
        source:             places_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - places_border_width
        height:             parent.height - places_border_width
        opacity:            places_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           places_border_radius
                    border.color:     places_border_color
                    border.width:     places_border_width
                    color:            "red"
                }
            }
        }
    }

    Flow {

        property string zap: placeEntry

        spacing:            parent.width / 40
        anchors.topMargin:  parent.width / 20
        anchors.leftMargin: parent.width / 20
        anchors.fill:       parent
        onZapChanged: {
            Qt.createQmlObject(
                "QPlaceButton {
                    qwidth:     parent.width - parent.width / 20
                    qheight:    parent.width / 8
                    qradius:    parent.width / 40
                    qtooltip:   '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                    qtext:      '"+zap.split(",",2).slice(zap.split(",",1).length)+"'
                    onQClicked: placeLaunch('xdg-open "+zap.split(",",1)+"')
                }", this, "../components/QPlaceButton")
        }
    }
}
