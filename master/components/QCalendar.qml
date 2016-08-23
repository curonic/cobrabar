import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {

    property int    qheight
    property int    qwidth
    property string qtime
    property string qdate
    property string qtextcolor
    property color  fontColor:  "#aaffffff"
    property string fontFamily: "Oxygen-Sans"

    width:                       qwidth
    height:                      qheight

    Column {
        anchors.fill:            parent

        Text {
            text:                qtime
            width:               parent.width
            font.pointSize:      parent.width > 0 ? parent.width / 8 : 1
            color:               fontColor
            font.family:         fontFamily
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
            color:               fontColor
            font.family:         fontFamily
            textFormat:          Text.RichText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:   Text.AlignVCenter
            wrapMode:            Text.WordWrap
            renderType:          Text.NativeRendering
        }
    }
}
