import QtQuick 2.15
import Components 1.0

Item {

    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom : parent.bottom
        }
        text: `TRACK DISPLAY PLACEHOLDER`
        color: Colors.white
        font.pixelSize: vh(6)
    }

    Canbus {
        interval: 1000
        onUpdate: {
        }
    }
}
