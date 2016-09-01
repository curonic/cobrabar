import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "qrc:/js/Theme.js" as Theme

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

    signal showPopup(int disk_qid)

    width:  qwidth
    height: qheight

    MouseArea {
    anchors.fill: parent
    onClicked: showPopup(qid)
    }
    Rectangle {

        anchors.fill:   parent

        color: Theme.NoColor


        Row {
            anchors.fill:               parent

            Column {
                width:  parent.width
                height: parent.height

                Row {
                    width:  parent.width
                    height: parent.height / 2

                    Rectangle {
                        width:  parent.width / 2
                        height: parent.height
                        color:  Theme.NoColor

                        Label {
                            color:  Theme.PlaceTextColor
                            text:   qlabel
                            font.pixelSize: parent.width > 0 ? parent.width / 8 : 1
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: parent.width / 40
                        }
                    }
                    Rectangle {
                        width: parent.width / 2
                        height: parent.height
                        color:          Theme.NoColor
                        Label {
                            color:  "orange"
                            text:   sizeingb+" Gb"
                            font.pixelSize: parent.width > 0 ? parent.width / 8 : 1
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: parent.width / 40
                        }
                    }

                }
                Rectangle {
                    width: parent.width - height
                    height: parent.height /2
                    color:          Theme.NoColor
                    x: height/2
                    Rectangle {
                        id: bar
                        width: parent.width
                        height: parent.height /2 - 1
                        y: parent.height / 8
                        radius: parent.height / 2
                        border.color: "black"
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#22269AFF" }
                            GradientStop { position: 1.0; color: "#22269AFF" }
                        }
                        Rectangle {
                            width: bar.height - 2
                            height: parent.width *  qfreespace / 100
                            rotation: 90
                            x: -1 + parent.width *  qfreespace / 200
                            radius: parent.height / 2
                            anchors.verticalCenter: bar.verticalCenter
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "orange" }
                                GradientStop { position: 1.0; color: "yellow" }
                            }
                        }



                        Label {
                            color:  Theme.PlaceTextColor
//                            text:   qfreespace+" %"
                            font.pixelSize: parent.width > 0 ? parent.width / 12 : 1
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }
}

