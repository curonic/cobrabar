import QtQuick 2.5
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import "../components/"

Item {

    anchors.fill: parent

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width
        height:             parent.height
        radius:             disks_radius
        border.color:       disks_border_color
        border.width:       disks_border_size
        color:              disks_background_color
    }

    Image {
        id:                 img
        source:             places_background_image
        anchors.centerIn:   parent
        layer.enabled:      true
        width:              parent.width - disks_border_size
        height:             parent.height - disks_border_size
        opacity:            disks_image_opacity

        layer.effect: OpacityMask {
            maskSource: Item {
                width:      img.width
                height:     img.height

                Rectangle {
                    anchors.centerIn: parent
                    width:            img.width
                    height:           img.height
                    radius:           disks_radius
                    border.color:     disks_border_color
                    border.width:     disks_border_size
                    color:            disks_background_color
                }
            }
        }
    }

    Flow {

        property string zap:    diskEntry

        spacing:            parent.width / 40
        anchors.topMargin:  parent.width / 20
        anchors.leftMargin: parent.width / 20
        anchors.fill:       parent
        onZapChanged: {
            Qt.createQmlObject(
                "QDiskInfo {
                    qwidth:      parent.width - parent.width / 10 + parent.width / 20
                    qheight:     parent.width / 8
                    qradius:     parent.width / 40
                    qdev:        '"+zap.split(",",1)+"';
                    qmountpoint: '"+zap.split(",",2).slice(zap.split(",",1).length)+"'
                    qfreespace:  '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                    sizeingb:    '"+zap.split(",",4).slice(zap.split(",",3).length)+"'
                    qlabel:      '"+zap.split(",",5).slice(zap.split(",",4).length)+"'
                    qid:         '"+zap.split(",",6).slice(zap.split(",",5).length)+"'
                    onQClicked:  placeLaunch('xdg-open '+qdev);
                }", this, "../components/QDiskInfo")
        }
    }
}
