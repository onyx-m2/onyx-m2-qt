import QtQuick 2.0
import Theme 1.0

Item  {
    property string value
    property string caption
    property string label

    // this control centers its two text fields, so we can't use childrenRect
    // to give the container a size because it creates a dependency loop, so
    // instead, we'll set the width to widest of the two text fields
    width: Math.max(valueText.width, labelText.width)
    height: childrenRect.height

    states: State {
        name: 'hero'
        PropertyChanges {
            target: valueText
            font.pixelSize: vh(22)
        }
        PropertyChanges {
            target: labelText
            font.pixelSize: vh(6)
            anchors.topMargin: vh(-2)
        }
    }

    Text {
        id: captionText
        anchors {
            bottom: valueText.top
            bottomMargin: vh(4)
            horizontalCenter: parent.horizontalCenter
        }
        color: Theme.primary
        font.pixelSize: vh(5)
        font.weight: Font.Bold
        text: caption
    }

    Text {
        id: valueText
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        color: Theme.primary
        font.pixelSize: vh(16)
        font.weight: Font.Light
        text: value
    }

    Text {
        id: labelText
        anchors {
            top: valueText.bottom
            topMargin: vh(-1)
            horizontalCenter: parent.horizontalCenter
        }

        color: Theme.primary
        font.pixelSize: vh(5)
        text: label
    }
}
