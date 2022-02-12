import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Theme 1.0
import Gauges 1.0

Item {
    id: app

    readonly property int rowSpacing: vh(3)

    readonly property int contourLineWidth: vh(0.8)
    readonly property int separatorLineWidth: 0.002 * height
    readonly property int gaugeBarWidth: vw(2)

    function vh(pct) { return pct * height / 100 }
    function vw(pct) { return pct * width / 100 }

    property string odometer: '0'
    property string capacity: '0'
    property string range: '400'

    property real time: 0

    // THe indicator bar is really thin and displays at the top of the screen
    IndicatorBar {
        id: indicatorBar
        width: vw(100)
        height: vh(0.6)
    }

    // The primary section holds the speed and battery gauges, as well as the PRND
    // indicator, and is the larger cluster
    PrimarySection {
        id: primarySection
        anchors {
            top: indicatorBar.bottom
            topMargin: rowSpacing
        }
        width: vw(100)
        height: vh(18)
    }

    // The power section shows power/regen for all motors, and is second in size to
    // the primary cluster
    PowerSection {
        id: powerSection
        anchors {
            top: primarySection.bottom
            topMargin: rowSpacing
        }
        width: vw(100)
        //height: 0//vh(1) + rowSpacing
    }

    SecondarySection {
        id: secondarySection
        anchors {
            top: powerSection.bottom
            topMargin: rowSpacing
        }
        width: vw(100)
        height: vh(18)
    }

    // time code indicator (debug)
    Rectangle {
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        width: childrenRect.width
        height: childrenRect.height
        Text {
            text: time
            font.pixelSize: vh(5)
        }
    }

    // Rectangle {
    //     id: separator
    //     anchors {
    //         left: parent.left
    //         right : parent.right
    //         top: parent.verticalCenter
    //         //topMargin: rowSpacing
    //         //bottom: parent.bottom
    //     }
    //     height: 1
    //     color: Colors.white
    // }

    // Rectangle {
    //     id: separator
    //     anchors {
    //         left: parent.left
    //         right : parent.right
    //         top: powerSection.bottom
    //         topMargin: rowSpacing
    //         //bottom: parent.bottom
    //     }
    //     height: childrenRect.height
    //     color: Colors.grey

    //     Text {
    //         text: "TEMPERATURES"
    //         font.weight: Font.Bold
    //     }

    //     Text {
    //         anchors {
    //             right: parent.right
    //         }
    //         text: "ENERGY"
    //         font.weight: Font.Bold
    //     }

    // }

    // LineGauge {
    //     //id: rangeIndicator
    //     anchors {
    //         top: separator.bottom
    //         topMargin: rowSpacing
    //         left: parent.left
    //     }
    //     width: vw(13)
    //     height: vh(8)
    //     caption: 'RANGE'
    //     value: 82
    //     color: Colors.white
    //     units: 'km'
    //     maxValue: 350
    // }

    // LineGauge {
    //     //id: rangeIndicator
    //     anchors {
    //         top: separator.bottom
    //         topMargin: rowSpacing
    //         right: parent.right
    //     }
    //     width: vw(33)
    //     height: vh(8)
    //     caption: 'RANGE'
    //     value: 82
    //     color: Colors.white
    //     units: 'km'
    //     maxValue: 350
    // }

    // LineGauge {
    //     id: rangeIndicator
    //     anchors {
    //         top: separator.bottom
    //         topMargin: rowSpacing
    //         left: parent.left
    //     }
    //     width: vw(33)
    //     height: vh(8)
    //     caption: 'RANGE'
    //     value: 82
    //     color: Colors.white
    //     units: 'km'
    //     maxValue: 350
    // }

    Canbus {
        onUpdate: {
            range = sig('UI_expectedRange').toLocaleString(Qt.locale('us_EN'), 'f', 0)

            odometer = sig('UI_odometer').toLocaleString(Qt.locale('us_EN'), 'f', 2)

            var nominalFullPack = sig('BMS_nominalFullPack')
            var initialFullPack = sig('BMS_initialFullPack')
            if (nominalFullPack !== 0 && initialFullPack !== 0) {
                const value = nominalFullPack * 100 / initialFullPack
                capacity = value.toLocaleString(Qt.locale('us_EN'), 'f', 0) + '%'
            }

            time = canbus.timestamp()//sig('UTC_seconds') //
            //console.log(sig('ESP_infoApplicationCRC'))
        }
    }
}
