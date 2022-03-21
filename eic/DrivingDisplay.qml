import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Components 1.0

Item {

    // The indicator bar is really thin and displays at the top of the screen
    IndicatorBar {
        id: indicatorBar
        width: vw(100)
        height: lineWidth * 2
    }

    // The primary section holds the speed and battery gauges, as well as the PRND
    // indicator, and is the larger cluster
    PrimarySection {
        id: primarySection
        anchors {
            top: indicatorBar.bottom
            topMargin: rowSpacing
            bottom: powerSection.top
            bottomMargin: rowSpacing
        }
        width: vw(100)
        //height: vh(25)
    }

    TripSection {
        id: secondarySection
        anchors {
            top: indicatorBar.bottom
            topMargin: rowSpacing
            bottom: powerSection.top
            bottomMargin: rowSpacing
        }
        width: vw(100)
        // height: vh(15)
    }

    // The power section shows power/regen for all motors, and is second in size to
    // the primary cluster
    PowerSection {
        id: powerSection
        anchors {
            bottom: parent.bottom
            bottomMargin: vh(6)
            //bottomMargin: batteryIndicator.height + rowSpacing
        }
        width: vw(100)
    }

    // BatteryIndicator {
    //     id: batteryIndicator
    //     anchors {
    //         bottom: parent.bottom
    //         right: parent.right
    //     }
    //     width: vw(9)
    //     height: vh(5)
    // }

}