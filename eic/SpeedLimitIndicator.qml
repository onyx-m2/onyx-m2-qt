import QtQuick 2.6
import QtQuick.Layouts 1.15
import Components 1.0

Rectangle {
    property int speedLimit: 30
    property bool speedLimitKnown: false

    radius: vw(1)//parent.width / 100
    color: speedLimitKnown ? Colors.white : Colors.grey
    //padding: 10
    //visible: speedLimitKnown

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

    Text {
        id: captionText
        anchors {
            top: parent.top
            topMargin: vh(3)
            horizontalCenter: parent.horizontalCenter
        }
        //width: parent.width
        //horizontalAlignment: Text.AlignHCenter
        font.pixelSize: vh(6)//parent.width * 0.30
        font.weight: Font.Bold
        text: 'MAX'
    }

    Text {
        id: valueText
        anchors {
            bottom: parent.bottom
            bottomMargin: vh(1)
            //bottom: parent.bottom
            //bottomMargin: captionText.height /2
            horizontalCenter: parent.horizontalCenter

        }
        horizontalAlignment: Text.AlignHCenter
        //color: 'black'
        //color: (value !== 0) ? gauge.color : Colors.grey
        font.pixelSize: vh(11)//parent.height / 2// * 0.30
        font.weight: Font.Bold
        font.letterSpacing: -10
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
