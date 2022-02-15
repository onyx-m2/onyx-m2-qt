import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Theme 1.0
import Gauges 1.0

Item {
    property int odometer: 0
    property int capacity: 0
    readonly property int indicatorWidth: vw(35)
    readonly property int indicatorHeight: vh(18)

    Image {
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        id: logo
        sourceSize.height: vh(35)
        fillMode: Image.PreserveAspectFit
        source: 'assets/tesla.png'
    }

    CaptionTextGauge {
        anchors {
            left: parent.left
            bottom : parent.bottom
        }
        width: indicatorWidth
        height: indicatorHeight
        caption: 'ODOMETER'
        value: odometer
    }

    CaptionTextGauge {
        anchors {
            right: parent.right
            bottom : parent.bottom
        }
        width: indicatorWidth
        height: indicatorHeight
        caption: 'CAPACITY'
        value: capacity
    }

    Canbus {
        interval: 1000
        onUpdate: {
            odometer = sig('UI_odometer')
            const nominalFullPack = sig('BMS_nominalFullPackEnergy')
            const initialFullPack = sig('BMS_initialFullPackEnergy')
            if (nominalFullPack !== 0 && initialFullPack !== 0) {
                capacity = nominalFullPack * 100 / initialFullPack
            }
        }
    }
}
