import QtQuick 2.15
import Theme 1.0

Item  {
    property string value
    property string label
    property int valueSize: vh(8)
    property int labelSize: vh(5)

    width: childrenRect.width
    height: childrenRect.height

    states: State {
        name: "labelLeft"
        AnchorChanges {
            target: labelText
            anchors.left: undefined
            anchors.right: valueText.left
        }
        PropertyChanges {
            target: labelText
            anchors.leftMargin: 0
            anchors.rightMargin: vh(2)
        }
    }

    Behavior on opacity {
        OpacityAnimator { duration: 300 }
    }

    Text {
        id: valueText
        color: Theme.primary
        font.pixelSize: valueSize
        text: value
    }

    Text {
        id: labelText
        anchors {
            left: valueText.right
            leftMargin: vw(1)
            bottom: valueText.bottom
            bottomMargin: vh(0.5)
        }
        color: Theme.primary
        font.pixelSize: labelSize
        text: label
    }
}
