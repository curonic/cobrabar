import QtQuick 2.5
import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    property string picture_

    anchors.fill:   parent

    Rectangle {
        anchors.fill:     parent
        color:            Theme.BackgroundColor

        Rectangle {
            id:               holder
            width:            parent.width - 30
            height:           parent.height - 30
            anchors.centerIn: parent
            color:            Theme.NoColor

            Image {
                id:               picture
                anchors.centerIn: holder
                anchors.fill:     holder
                source:           picture_
                fillMode:         Image.PreserveAspectFit
            }
        }
    }
}
