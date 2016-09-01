import QtQuick 2.5
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill:       parent

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width
        height:             parent.height
        radius:             applications_radius
        border.color:       applications_border_color
        border.width:       applications_border_size
        color:              applications_background_color
    }

    Image {
        id:                 img
        source:             applications_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - applications_border_size
        height:             parent.height - applications_border_size
        opacity:            applications_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           applications_radius
                    border.color:     applications_border_color
                    border.width:     applications_border_size
                    color:            applications_background_color
                }
            }
        }
    }

    Flow {
        property string zap: applicationEntry

        anchors.leftMargin: parent.width / 25;
        anchors.topMargin:  parent.width / 25;
        anchors.fill:       parent
        spacing:            parent.width / 20;
        anchors.centerIn:   parent
        onZapChanged: {
            Qt.createQmlObject(
              "QButton {
                qwidth:     parent.width / 5
                qheight:    parent.width / 5
                qradius:    parent.width / 40
                qtooltip:   '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                qicon:      'file:/"+applicationIcon+zap.split(",",2).slice(zap.split(",",1).length)+"';
                onQClicked: applicationLaunch('"+zap.split(",",1)+"')
                }", this, "../components/QButton")
        }
    }
}

