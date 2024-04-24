import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    id: gauge

    property string caption
    property string value
    property string suffix
    property color color: Colors.white

    //width: childrenRect.width
    //height: childrenRect.height
    //anchors.fill: parent

    Text {
        id: captionText
        anchors {
            bottom: valueText.top
            bottomMargin: vh(5)
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        color: Colors.grey
        font.pixelSize: vh(5)
        font.weight: Font.Bold
        text: caption
    }

    Text {
        id: valueText
        anchors {
            //top: captionText.bottom
            //topMargin: vh(3)
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        //width: parent.width
        horizontalAlignment: Text.AlignHCenter
        color: Colors.white
        font.pixelSize: vh(8)
        //font.weight: Font.Light
        text: value
    }

    Text {
        id: suffixText
        anchors {
            top: valueText.bottom
            topMargin: vh(2)
            horizontalCenter: parent.horizontalCenter
            // bottom: valueText.bottom
            // left: valueText.right
            // leftMargin: vw(1)
        }
        //width: parent.width
        horizontalAlignment: Text.AlignHCenter
        color: Colors.grey
        font.pixelSize: vh(5)
        //font.weight: Font.Medium
        text: suffix
    }

}
