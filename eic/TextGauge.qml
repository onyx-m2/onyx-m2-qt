import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    id: indicator
    //border.color: 'blue'

    property real value
    property string units
    property color color: Colors.white

    property int fontSize: height * 0.80
    property int unitsFontSize: height * 0.14

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

    Text {
        id: valueText
        anchors {
            top: parent.top
            topMargin: vh(-0.6)
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        color: (value !== 0) ? indicator.color : Colors.grey
        font.pixelSize: parent.height * 1.2
        font.weight: Font.Thin
        text: value
    }

    Text {
        id: unitsText
        anchors {
            //right: valueText.right
            //horizontalCenter: parent.horizontalCenter
            top: valueText.bottom
            //bottomMargin: vh(1)
            //leftMargin: parent.height * 0.1
            //bottom: valueText.bottom
            //bottomMargin: vh(2)
            //topMargin: -parent.height * 0.1
            //left: parent.left
        }
    //     // anchors {
    //     //     left: valueText.right
    //     //     leftMargin: parent.height * 0.1
    //     //     bottom: valueText.bottom
    //     //     bottomMargin: parent.height * 0.1
    //     //     //topMargin: -parent.height * 0.1
    //     //     //left: parent.left
    //     // }
    //     // anchors {
    //     //     horizontalCenter: valueText.horizontalCenter
    //     //     top: valueText.bottom
    //     //     topMargin: -parent.height * 0.1
    //     //     //left: parent.left
    //     // }
    //     color: (value !== 0) ? indicator.color : Colors.grey
    //     font.pixelSize: unitsFontSize
    //     text: units
    //     //rotation: 270
    //     transform: [
    //         Rotation { origin.x: unitsText.width; origin.y: 0; angle: -90},
    //         Translate { y: -unitsText.width }
    //     ]
    // }
}
