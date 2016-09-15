import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {

    property int    qheight
    property int    qwidth
    property string qtime
    property string qdate
    property color  qdatecolor
    property font   qdatefontfamily
    property color  qtimecolor
    property font   qtimefontfamily

    width:                       qwidth
    height:                      qheight

    Column {
        anchors.fill:            parent

        Text {
            text:                qtime
            width:               parent.width
            font.pointSize:      parent.width > 0 ? parent.width / 8 : 1
            color:               qtimecolor
            font.family:         qtimefontfamily
            textFormat:          Text.RichText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:   Text.AlignVCenter
            wrapMode:            Text.WordWrap
            renderType:          Text.NativeRendering
        }

        Text {
            text:                qdate
            width:               parent.width
            font.pointSize:      parent.width > 0 ? parent.width / 14 : 1
            color:               qdatecolor
            font.family:         qdatefontfamily
            textFormat:          Text.RichText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:   Text.AlignVCenter
            wrapMode:            Text.WordWrap
            renderType:          Text.NativeRendering
        }
    }
}
