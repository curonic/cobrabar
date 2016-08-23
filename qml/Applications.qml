import QtQuick 2.5
import "../components/"

Item {

    anchors.fill:       parent

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

