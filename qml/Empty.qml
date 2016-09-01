import QtQuick 2.5
import QtQuick.Layouts 1.1

import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    anchors.fill:   parent

    Rectangle {
        anchors.fill:   parent
        color:          Theme.BackgroundColor

        Column {
            anchors.fill: parent
            Item {
                width: parent.width
                height: parent.height/3
Loader {id: applications; source: "qrc:/qml/Pins.qml";}
            }
            Item {
                width: parent.width
                height: parent.height /3
                Rectangle {
                    anchors.fill:   parent
                    color: "green"
                }
            }
            Item {
                width: parent.width
                height: parent.height /3
                Rectangle {
                    anchors.fill:   parent
                    color: "red"
                }
            }
        }
    }

}

