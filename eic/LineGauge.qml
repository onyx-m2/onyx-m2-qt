import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    id: gauge
    property real value
    property real maxValue
    property color color: Colors.white

    states: [
        State {
            name: 'reverse'
            AnchorChanges {
                target: label
                anchors.left: undefined
                anchors.right: parent.right
            }
            PropertyChanges {
                target: label
                anchors.leftMargin: undefined
                anchors.rightMargin: valueBar.width - width
                horizontalAlignment: Text.AlignLeft
            }
            AnchorChanges {
                target: valueBar
                anchors.left: undefined
                anchors.right: parent.right
            }
        },
        State {
            name: 'labelAbove'
            AnchorChanges {
                target: label
                anchors.top: undefined
                anchors.bottom: parent.top
            }
        },
        State {
            name: 'reverseLabelAbove'
            AnchorChanges {
                target: label
                anchors.top: undefined
                anchors.bottom: parent.top
                anchors.left: undefined
                anchors.right: parent.right
            }
            PropertyChanges {
                target: label
                anchors.leftMargin: undefined
                anchors.rightMargin: valueBar.width - width
                horizontalAlignment: Text.AlignLeft
            }
            AnchorChanges {
                target: valueBar
                anchors.left: undefined
                anchors.right: parent.right
            }
        }
    ]

    // Rectangle {
    //     id: backgroundBar
    //     width: parent.width
    //     height: parent.height
    //     color: Colors.grey
    // }

    Rectangle {
        id: valueBar
        width: parent.width * Math.min(value / maxValue, maxValue)
        height: parent.height
        color: gauge.color
        visible: maxValue > 0

        Behavior on width {
            NumberAnimation  {
                easing.type: Easing.InOutQuad
                duration: 300
            }
        }
    }

    Text {
        id: label
        anchors {
            top: parent.top
            topMargin: vh(1)
            left: parent.left
            leftMargin: valueBar.width - width
        }
        text: value
        horizontalAlignment: Text.AlignRight
        color: gauge.color
        visible: value != 0
        font.pixelSize: vh(6)
    }

    // Rectangle {
    //     anchors {
    //         top: parent.top
    //         left: parent.left
    //         leftMargin: valueBar.width
    //     }
    //     width: childrenRect.width
    //     height: childrenRect.height
    //     Text {
    //         text: value
    //     }
    //     color: gauge.color
    //     visible: value != 0
    // }

}
