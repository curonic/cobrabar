import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {

    property int    qheight
    property int    qwidth
    property int    qradius
    property string qicon
    property string qdev
    property string qmountpoint
    property string qfreespace
    property string sizeingb
    property string qlabel
    property string qid

    width:  qwidth
    height: qheight

    signal qClicked()

    Rectangle {

        anchors.fill: parent
        radius:       qradius
        border.color: "#22000000"
        gradient: Gradient {
            GradientStop { position: 0; color: "#555" }
            GradientStop { position: 1; color: "#222" }
        }

        MouseArea {
            anchors.fill: parent
            onClicked:    qClicked()
        }

        Column {
            width:      parent.width
            height:     parent.height

            Row {
                width:  parent.width
                height: parent.height / 1.5

                Rectangle {
                    width:  parent.width / 2
                    height: parent.height
                    color:  "#00000000"

                    Label {
                        color:            "#aaffffff"
                        text:             qlabel
                        font.pixelSize:   parent.width > 0 ? parent.width / 7 : 1
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: parent.width / 40
                    }
                }

                Rectangle {
                    width:  parent.width / 2
                    height: parent.height
                    color:  "#00000000"

                    Label {
                        color:               "#FF8000"
                        height:              parent.height
                        width:               parent.width
                        text:                sizeingb+" Gb  "
                        font.pixelSize:      parent.width > 0 ? parent.width / 9 : 1
                        verticalAlignment:   Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            Rectangle {
                width:  parent.width - height
                height: parent.height / 2
                color:  "#00000000"
                x:      height / 2

                Rectangle {
                    id:           bar
                    width:        parent.width
                    height:       parent.height / 2 - 1
                    y:            parent.height / 8
                    radius:       parent.height / 2
                    border.color: "#33000000"
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#33aaaaaa" }
                        GradientStop { position: 1.0; color: "#33aaaaaa" }
                    }

                    Rectangle {
                        width:    bar.height - 3
                        height:   parent.width *  qfreespace / 100
                        rotation: 90
                        x:        -1 + parent.width *  qfreespace / 200
                        radius:   parent.height / 2
                        color:    "#aaFF8000"
                        anchors.verticalCenter: bar.verticalCenter
                    }
                }
            }
        }
    }
}

