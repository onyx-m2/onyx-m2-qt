import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    id: gauge

    property string caption
    property real value
    property color color: Colors.white

    Text {
        id: captionText
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        color: (value !== 0) ? gauge.color : Colors.grey
        font.pixelSize: gauge.height * 0.35
        font.weight: Font.Medium
        text: caption
    }

    Text {
        id: valueText
        anchors {
            top: captionText.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: vh(2)
        }
        horizontalAlignment: Text.AlignHCenter
        color: (value !== 0) ? gauge.color : Colors.grey
        font.pixelSize: gauge.height * 0.6
        font.weight: Font.Light
        text: value
    }
}
