import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int currentOverlay: 0
    property var overlays: [
        'TripOverlay.qml',
        'PowerOverlay.qml',
        'TemperatureOverlay.qml',
        'TirePressureOverlay.qml',
    ]
    property int scrollWheelIgnoreCycles: 0

    property int gear: 7 // SNA
    property int autopilotState: 0
    property int handsOnState: 0

    property int breakLightStatus: 0
    property int leftTurnLightStatus: 0
    property int rightTurnLightStatus: 0

    readonly property int indicatorWidth: vw(10)
    readonly property int indicatorHeight: vh(1.2)
    readonly property int indicatorRadius: 0

    anchors.centerIn: parent

    Item {
        id: gearIndicator
        anchors {
            top: parent.top
            left: parent.left
        }

        RowLayout {
            Text {
                text: 'P'
                color: gear === 1 ? Colors.white : Colors.grey
                font.weight: gear === 1 ? Font.Bold : Font.Normal
            }
            Text {
                text: 'R'
                color: gear === 2 ? Colors.white : Colors.grey
                font.weight: gear === 2 ? Font.Bold : Font.Normal
            }
            Text {
                text: 'N'
                color: gear === 3 ? Colors.white : Colors.grey
                font.weight: gear === 3 ? Font.Bold : Font.Normal
            }
            Text {
                text: 'D'
                color: gear === 4 ? Colors.white : Colors.grey
                font.weight: gear === 4 ? Font.Bold : Font.Normal
            }
        }
    }

    BatteryIndicator {
        id: batteryIndicator
        anchors {
            top: parent.top
            right: parent.right
        }
        width: vw(7)
        height: vh(5)
    }

    // The power section shows power/regen for all motors, and is second in size to
    // the primary cluster
    PowerSection {
        id: powerSection
        anchors {
            top: batteryIndicator.bottom
            topMargin: rowSpacing / 2
        }
        width: vw(100)
    }

    SpeedIndicator {
        anchors {
            top: powerSection.bottom
            topMargin: rowSpacing
            horizontalCenter: parent.horizontalCenter
        }
        width: vw(30)
        height: vh(38)
    }

    Loader {
        id: overlay
        anchors {
            top: powerSection.bottom
            topMargin: rowSpacing
            bottom: parent.bottom
            bottomMargin: rowSpacing
            horizontalCenter: parent.horizontalCenter
        }
        width: vw(100)
        source: overlays[0]
    }

    // left turn indicator
    Rectangle {
        id: leftTurnIndicator
        anchors {
            left: parent.left
            bottom: parent.bottom
            bottomMargin: vh(2)
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: indicatorHeight
        color: Colors.green
        opacity: (leftTurnLightStatus === 1) ? 1.0 : 0.0
    }

    // braking indicator
    Rectangle {
        id: stopIndicator
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: vh(2)
        }
        width: indicatorWidth * 4
        radius: indicatorRadius
        height: indicatorHeight
        color: Colors.red
        opacity: (breakLightStatus === 1 /* ON */) ? 1.0 : 0.0
    }

    // right turn indicator
    Rectangle {
        id: rightTurnIndicator
        anchors {
            right: parent.right
            bottom: parent.bottom
            bottomMargin: vh(2)
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: indicatorHeight
        color: Colors.green
        opacity: (rightTurnLightStatus === 1) ? 1.0 : 0.0
    }

    // need a really short interval here because we're polling
    // for scroll ticks and we'll just not see them if the interval
    // is too long; we'll still debounce to avoid cycling more than
    // one overlay per "flip" of the wheel
    Canbus {
        interval: 10
        onUpdate: {
            breakLightStatus = sig('VCRIGHT_brakeLightStatus')
            leftTurnLightStatus = sig('VCLEFT_turnSignalStatus')
            rightTurnLightStatus = sig('VCRIGHT_turnSignalStatus')
            if (breakLightStatus === 1 /* ON */) {
                leftTurnLightStatus = !leftTurnLightStatus
                rightTurnLightStatus = !rightTurnLightStatus
            }

            if (scrollWheelIgnoreCycles == 0) {
                const autopilotState = sig('DAS_autopilotState')
                if (autopilotState !== 3 /* ACTIVE_NOMINAL */) {
                    const ticks = sig('VCLEFT_swcRightScrollTicks')
                    if (ticks > 0) {
                        scrollDisplayUp()
                        scrollWheelIgnoreCycles = 50
                    }
                    else
                    if (ticks < 0) {
                        scrollDisplayDown()
                        scrollWheelIgnoreCycles = 50
                    }
                }
            }
            else {
                scrollWheelIgnoreCycles--
            }

            gear = sig('DI_gear')
            autopilotState = sig('DAS_autopilotState')
        }
    }

    function scrollDisplayUp() {
        currentOverlay = currentOverlay < overlays.length - 1 ? currentOverlay + 1 : 0
        overlay.source = overlays[currentOverlay]
    }

    function scrollDisplayDown() {
        currentOverlay = currentOverlay > 0 ? currentOverlay - 1 : overlays.length - 1
        overlay.source = overlays[currentOverlay]
    }

    focus: true
    Keys.onPressed: (e) => {
        switch (e.key) {
            case Qt.Key_PageUp:
                scrollDisplayUp()
                break

            case Qt.Key_PageDown:
                scrollDisplayDown()
                break

            default: return
        }
        e.accepted = true
    }


}
