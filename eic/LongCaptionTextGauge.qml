import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    id: gauge

    property string caption
    property string value
    property color color: Colors.white


    Text {
        id: valueText
        anchors {
            top: parent.top
            left: parent.right
            leftMargin: -parent.width / 3
            //top: captionText.bottom
            //horizontalCenter: parent.horizontalCenter
            //topMargin: vh(2)

        }
        //horizontalAlignment: Text.AlignHCenter
        color: Colors.white
        font.pixelSize: gauge.height
        //font.weight: Font.Light
        text: value
    }

    Text {
        id: captionText
        anchors {
            top: parent.top
            right: valueText.left
            rightMargin: parent.width / 20
        }
        //width: parent.width
        horizontalAlignment: Text.AlignRight
        color: Colors.grey
        font.pixelSize: gauge.height
        //font.weight: Font.Medium
        text: caption
    }
}
