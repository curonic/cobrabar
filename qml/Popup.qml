import QtQuick 2.5
import "../components/"
import "qrc:/js/Theme.js" as Theme

Item {

    anchors.fill:   parent
    Rectangle {
    anchors.fill: parent
    }

    QPopup {
        anchors.fill:       parent
        qtext:              new Date().toLocaleDateString(Qt.locale(Theme.Locale+".UTF-8"), "dddd")

    }
}
