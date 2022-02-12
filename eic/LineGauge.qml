import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    //border.color: 'red'
    id: indicator
    property real value
    property real maxValue
    property color color: Colors.white

    states: State {
        name: 'reverse'
        AnchorChanges {
            target: backgroundBar
            anchors.left: undefined
            anchors.right: parent.right
        }
        AnchorChanges {
            target: valueBar
            anchors.left: undefined
            anchors.right: parent.right
        }
    }

    Rectangle {
        id: backgroundBar
        width: parent.width
        height: vh(0.6)
        // anchors {
        //     left: parent.left
        //     bottom: parent.bottom
        // }
        color: Colors.grey
    }

    Rectangle {
        id: valueBar
        width: parent.width * Math.min(value / maxValue, maxValue)
        height: vh(0.6)
        // anchors {
        //     bottom: parent.bottom
        // }
        color: indicator.color
        visible: maxValue > 0

        Behavior on width {
            NumberAnimation  {
                easing.type: Easing.InOutQuad
                duration: 300
            }
        }
    }
}
