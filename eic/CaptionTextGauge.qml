import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    id: gauge
    //border.color: 'blue'

    property string caption
    property real value
    property string units
    property color color: Colors.white

    property int unitsFontSize: height * 0.3

    // Rectangle {
    //     anchors {
    //         fill: valueText
    //         //margins: -8
    //     }
    //     //radius: 10
    //     color: 'blue'
    // }

    // states: State {
    //     name: 'rightAligned'
    //     AnchorChanges {
    //         target: valueText
    //         anchors.left: undefined
    //         anchors.right: parent.right
    //     }
    //     PropertyChanges {
    //         target: valueText
    //         horizontalAlignment: Text.AlignRight
    //     }
    //     AnchorChanges {
    //         target: unitsText
    //         anchors.left: undefined
    //         anchors.right: parent.right
    //     }
    //     PropertyChanges {
    //         target: unitsText
    //         horizontalAlignment: Text.AlignRight
    //     }
    // }

//    width: vw(20)
    Rectangle {
        id: captionText
        color: Colors.white
        width: parent.width
        height: childrenRect.height
        radius: 4

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: unitsFontSize
            font.weight: Font.Bold
            text: caption
        }

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
        font.pixelSize: gauge.height - unitsFontSize - vh(1)
        font.weight: Font.Light
        text: value
    }

    // Item {
    //     anchors {
    //         top: captionText.bottom
    //         topMargin: vh(2)
    //         horizontalCenter: parent.horizontalCenter
    //     }
    //     width: childrenRect.width
    //     Text {
    //         id: valueText
    //         anchors {
    //             top: parent.top
    //             topMargin: vh(-2)
    //         }
    //         horizontalAlignment: Text.AlignHCenter
    //         color: (value !== 0) ? gauge.color : Colors.grey
    //         font.pixelSize: gauge.height - unitsFontSize
    //         font.weight: Font.Light
    //         text: value
    //     }
    //     // Text {
    //     //     id: unitsText
    //     //     anchors {
    //     //         bottom: valueText.bottom
    //     //         bottomMargin: vh(1)
    //     //         left: valueText.right
    //     //     }
    //     //     color: (value !== 0) ? gauge.color : Colors.grey
    //     //     font.pixelSize: unitsFontSize
    //     //     text: units
    //     // }
    // }

}
