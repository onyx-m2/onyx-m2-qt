import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property string name
    property string value
    width: childrenRect.width
    height: childrenRect.height

    Text {
        id: nameText
        anchors {
            top: parent.top
        }
        horizontalAlignment: Text.AlignHCenter
        color: Colors.grey
        font.pixelSize: vh(4)
        text: `${name}: `
    }

    Text {
        anchors {
            left: nameText.right
        }
        color: Colors.white
        font.pixelSize: vh(4)
        text: value
    }

    Canbus {
        onUpdate: {
            value = Math.round((sig(name) + Number.EPSILON) * 100) / 100
        }
    }
}
