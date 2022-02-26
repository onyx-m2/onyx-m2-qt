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
        height: lineWidth
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

    SecondarySection {
        id: secondarySection
        anchors {
            top: primarySection.bottom
            topMargin: rowSpacing
        }
        width: vw(100)
        height: vh(15)
    }

    // The power section shows power/regen for all motors, and is second in size to
    // the primary cluster
    PowerSection {
        id: powerSection
        anchors {
            bottom: parent.bottom
        }
        width: vw(100)
    }
}