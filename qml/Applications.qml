import QtQuick 2.5
import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    property string apps_
    property string icons_

    signal applicationLaunch(string application_name)

    anchors.fill:       parent

    Rectangle {
        anchors.fill:   parent
        color:          Theme.BackgroundColor
    }

    Flow {
        property string zap: apps_

        anchors.leftMargin: parent.width / 25;
        anchors.topMargin:  parent.width / 25;
        anchors.fill:       parent
        spacing:            parent.width / 20;
        anchors.centerIn:   parent

        onZapChanged: {
            Qt.createQmlObject("
                QButton {
                    qwidth:     parent.width / 5
                    qheight:    parent.width / 5
                    qradius:    parent.width / 40
                    qtooltip:   '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
                    qicon:      'file:/"+icons_+zap.split(",",2).slice(zap.split(",",1).length)+"';
                    onQClicked: {

                        applicationLaunch('"+zap.split(",",1)+"')

                    }

                }", this, "../components/")
        }
    }
}

