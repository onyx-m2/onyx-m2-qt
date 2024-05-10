import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {

    //border.color: 'blue'
    width: childrenRect.width
    height: childrenRect.height

    property string name
    property string value

    // property int fontSize: height * 0.80
    // property int unitsFontSize: height * 0.14

    Text {
        id: nameText
        anchors {
            top: parent.top
        }
        horizontalAlignment: Text.AlignHCenter
        color: Colors.grey
        font.pixelSize: vh(4)
        //font.weight: Font.Thin
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
            //value = sig(name).toFixed(2)
        }
    }
}
