import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    id: indicator
    //border.color: 'blue'

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

    Text {
        id: valueText
        anchors {
            top: parent.top
            //topMargin: vh(-4)
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        color: (value !== 0) ? indicator.color : Colors.grey
        font.pixelSize: parent.height
        font.weight: Font.Light
        text: value
    }

    Text {
        id: unitsText
        anchors {
            horizontalCenter: valueText.horizontalCenter
            top: valueText.bottom
            topMargin: -parent.height * 0.12
            //left: parent.left
        }
        color: (value !== 0) ? indicator.color : Colors.grey
        font.pixelSize: unitsFontSize
        text: units
    }
}
