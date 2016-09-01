import QtQuick 2.5
import QtQuick.Layouts 1.0
import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    property string places_

    signal applicationLaunch(string application_name)

    anchors.fill:   parent

    Rectangle {
        anchors.fill:   parent
        color:          Theme.BackgroundColor
    }

    Flow {

        property string zap:    places_

        spacing:            parent.width / 40
        anchors.topMargin:  parent.width / 20
        anchors.leftMargin: parent.width / 20
        anchors.fill:       parent

        onZapChanged: {

            Qt.createQmlObject("
    QPlaceButton {
        qwidth:         parent.width - parent.width / 10 + parent.width / 20;
        qheight:        parent.width / 8;
        qradius:        parent.width / 40;
        qtooltip:       '"+zap.split(",",3).slice(zap.split(",",2).length)+"'
        qtext:          '"+zap.split(",",2).slice(zap.split(",",1).length)+"';
        onQClicked:     { applicationLaunch('"+zap.split(",",1)+"'); }

    }", this, "../components/QPlaceButton")

        }
    }
}
