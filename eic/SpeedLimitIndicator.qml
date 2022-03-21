import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Rectangle {
    property int speedLimit: 30
    property bool speedLimitKnown: false

    radius: parent.width / 100
    color: speedLimitKnown ? Colors.grey : Colors.black
    visible: speedLimitKnown

    // CaptionTextGauge {
    //     anchors {
    //         left: parent.left
    //         leftMargin: rowSpacing
    //     }
    //     width: smallIndicatorWidth
    //     height: vh(18)
    //     caption: "MAX"
    //     value: speedLimit

    // }

    // Text {
    //     id: captionText
    //     anchors {
    //         top: parent.top
    //         //topMargin: vh(2)
    //     }
    //     //width: parent.width
    //     //horizontalAlignment: Text.AlignHCenter
    //     font.pixelSize: parent.width * 0.30
    //     //font.weight: Font.Medium
    //     text: 'MAX'
    // }

    Text {
        id: valueText
        anchors {
            //bottom: parent.bottom
            //bottomMargin: captionText.height /2
            horizontalCenter: parent.horizontalCenter

            //top: captionText.top
            //left: captionText.right
            //topMargin: vh(2)
        }
        horizontalAlignment: Text.AlignHCenter
        //color: 'black'
        //color: (value !== 0) ? gauge.color : Colors.grey
        font.pixelSize: parent.width * 0.30
        //font.weight: Font.Medium
        text: speedLimit
    }

    Canbus {
        onUpdate: {
            var fusedLimit = sig('DAS_fusedSpeedLimit')
            if (fusedLimit !== 0 && fusedLimit !== 31 /* NONE */) {
                speedLimitKnown = true
                speedLimit = fusedLimit
            } else {
                speedLimitKnown = false
            }
        }
    }

}
