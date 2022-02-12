import QtQuick 2.15
import Theme 1.0

Item {
    property string caption
    property color wrapper

    anchors {
        centerIn: parent
        verticalCenterOffset: vh(6)
    }

    width: parent.width
    height: parent.height * 0.18

    Behavior on opacity {
        OpacityAnimator { duration: 300 }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "black" }
            GradientStop { position: 0.5; color: wrapper }
            //GradientStop { position: 0.5; color: Colors.red }
            GradientStop { position: 1.0; color: "black" }
        }
    }

    Text {
        anchors.centerIn: parent
        font.pointSize: vh(6)
        font.weight: Font.ExtraBold
        color: 'black'
        text: caption
    }
}
