import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {

    property string qdate
    property color  qdatecolor
    property font   qdatefontfamily
    property string qtime
    property color  qtimecolor
    property font   qtimefontfamily

    Column {
        anchors.fill:      parent
        spacing:           0
        anchors.topMargin: parent.width * 0.1

        Rectangle {
            id:     time_placeholder
            width:  parent.width
            height: parent.height * 0.5
            color:  "#0000ff00"
            Text {
                id:                       time
                text:                     qtime
                width:                    time_placeholder.width
                height:                   time_placeholder.height
                anchors.horizontalCenter: time_placeholder.horizontalCenter
                font.pointSize:           parent.width > 0 ? parent.width * 0.12 : 1
                color:                    qtimecolor
                font.family:              qtimefontfamily
                horizontalAlignment:      Text.AlignHCenter
                verticalAlignment:        Text.AlignBottom
                renderType:               Text.NativeRendering
            }
        }

        Rectangle {
            id:     date_placeholder
            width:  parent.width
            height: parent.height * 0.4
            color:  "#00ff0000"

            Text {
                id:                       date
                text:                     qdate
                width:                    parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize:           parent.width > 0 ? parent.width * 0.07 : 1
                color:                    qdatecolor
                font.family:              qdatefontfamily
                font.bold:                true
                horizontalAlignment:      Text.AlignHCenter
                verticalAlignment:        Text.AlignTop
                renderType:               Text.NativeRendering
            }
        }
    }
}
