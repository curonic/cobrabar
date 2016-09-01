import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "qrc:/js/Theme.js" as Theme

Item {

    property string qtext

    Rectangle {
        anchors.centerIn:   parent
        width:              parent.width - Math.sqrt( pp.width * pp.width + pp.height * pp.height) + 2
        height:             parent.height
        color:              Theme.BackgroundColor
        radius:             parent.width / 50

        Text {
            anchors.centerIn:   parent
            color:              Theme.PopupTextColor
            font.weight:        Font.Bold
            text:               qtext
        }
    }

    Rectangle {
        id:                             pp
        anchors.verticalCenter:         parent.verticalCenter
        anchors.horizontalCenter:       parent.horizontalCenter
        anchors.horizontalCenterOffset: parent.width / 2 - Math.sqrt( width * width + height * height) / 2
        width:                          parent.height / 3
        height:                         parent.height / 3
        color:                          Theme.NoColor
        rotation:                       315

        LinearGradient {
            anchors.fill:   parent
            start:          Qt.point(0,0)
            end:            Qt.point(height,width)

            gradient: Gradient {
                GradientStop { position: 0.00; color: Theme.NoColor }
                GradientStop { position: 0.52; color: Theme.NoColor }
                GradientStop { position: 0.53; color: Theme.PopupBackgroundColor }
                GradientStop { position: 1.00; color: Theme.PopupBackgroundColor }
            }
        }
    }
}
