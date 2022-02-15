import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Theme 1.0
import Gauges 1.0

Item {
    property real odometer: 0
    property int soc: 0
    property int capacity: 0
    readonly property int indicatorWidth: vw(35)
    readonly property int indicatorHeight: vh(18)

    Image {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        id: logo
        sourceSize.height: vh(30)
        fillMode: Image.PreserveAspectFit
        source: 'assets/tesla.png'
    }

    CaptionTextGauge {
        anchors {
            left: parent.left
            bottom : parent.verticalCenter
            bottomMargin: rowSpacing
        }
        width: indicatorWidth
        height: indicatorHeight
        caption: 'Trip'
        value: tripStartOdometer != 0 ? odometer - tripStartOdometer : 0
    }

    CaptionTextGauge {
        anchors {
            left: parent.left
            top : parent.verticalCenter
            topMargin: rowSpacing
        }
        width: indicatorWidth
        height: indicatorHeight
        caption: 'Odometer'
        value: Math.round(odometer)
    }

    CaptionTextGauge {
        anchors {
            right: parent.right
            bottom : parent.verticalCenter
            bottomMargin: rowSpacing
        }
        width: indicatorWidth
        height: indicatorHeight
        caption: 'Battery'
        value: soc
    }

    CaptionTextGauge {
        anchors {
            right: parent.right
            top : parent.verticalCenter
            topMargin: rowSpacing
        }
        width: indicatorWidth
        height: indicatorHeight
        caption: 'Capacity'
        value: capacity
    }

    Canbus {
        interval: 1000
        onUpdate: {
            odometer = sig('UI_odometer')
            soc = sig('UI_usableSOC')
            const nominalFullPack = sig('BMS_nominalFullPackEnergy')
            const initialFullPack = sig('BMS_initialFullPackEnergy')
            if (nominalFullPack !== 0 && initialFullPack !== 0) {
                capacity = nominalFullPack * 100 / initialFullPack
            }
        }
    }
}
