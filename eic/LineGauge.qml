import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
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
        height: parent.height
        color: Colors.grey
    }

    Rectangle {
        id: valueBar
        width: parent.width * Math.min(value / maxValue, maxValue)
        height: parent.height
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
