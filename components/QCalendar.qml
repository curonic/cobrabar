import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {

    property string qcal
    property color  qcalcolor
    property font   qcalfontfamily

    anchors.fill: parent

    Text {
        text:                     qcal
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize:           parent.height > 0 ? parent.height * 0.7 : 1
        color:                    qcalcolor
        font.family:              qcalfontfamily
        anchors.centerIn:         parent
        renderType:               Text.NativeRendering
    }
}
