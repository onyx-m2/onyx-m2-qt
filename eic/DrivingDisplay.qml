import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int currentOverlay: 0
    property var overlays: [
        'TripOverlay.qml',
        'TemperatureOverlay.qml',
        'TirePressureOverlay.qml'
    ]
    property int scrollWheelIgnoreCycles: 0


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

    Loader {
        id: overlay
        anchors {
            top: indicatorBar.bottom
            topMargin: rowSpacing
            bottom: powerSection.top
            bottomMargin: rowSpacing
        }
        width: vw(100)
        source: overlays[0]
    }

    // TripSection {
    //     id: secondarySection
    //     anchors {
    //         top: indicatorBar.bottom
    //         topMargin: rowSpacing
    //         bottom: powerSection.top
    //         bottomMargin: rowSpacing
    //     }
    //     width: vw(100)
    //     // height: vh(15)
    // }

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

    // need a really short interval here because we're polling
    // for scroll ticks and we'll just not see them if the interval
    // is too long; we'll still debounce to avoid cycling more than
    // one overlay per "flip" of the wheel
    Canbus {
        interval: 10
        onUpdate: {
            if (scrollWheelIgnoreCycles == 0) {
                const autopilotState = sig('DAS_autopilotState')
                if (autopilotState !== 3 /* ACTIVE_NOMINAL */) {
                    const ticks = sig('VCLEFT_swcRightScrollTicks')
                    if (ticks > 0) {
                        currentOverlay = currentOverlay < overlays.length - 1 ? currentOverlay + 1 : 0
                        overlay.source = overlays[currentOverlay]
                        scrollWheelIgnoreCycles = 50
                    }
                    else
                    if (ticks < 0) {
                        currentOverlay = currentOverlay > 0 ? currentOverlay - 1 : overlays.length - 1
                        overlay.source = overlays[currentOverlay]
                        scrollWheelIgnoreCycles = 50
                    }
                }
            }
            else {
                scrollWheelIgnoreCycles--
            }
        }
    }

}