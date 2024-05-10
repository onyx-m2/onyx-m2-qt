import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    id: indicator

    property string value
    property string units
    property color color: Colors.white

    property int fontSize: height * 0.80
    property int unitsFontSize: height * 0.14

    Text {
        id: valueText
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        color: (value != 0) ? indicator.color : Colors.grey
        font.pixelSize: fontSize
        font.weight: Font.Thin
        text: value
    }

    Text {
        id: unitsText
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: valueText.bottom
        }
        color: /*(value !== 0) ? indicator.color : */Colors.grey
        font.pixelSize: unitsFontSize
        text: units
    }
}
