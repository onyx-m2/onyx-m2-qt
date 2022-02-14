import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    property int gear: 7 // SNA
    property int ebrStatus: 0
    property int autopilotState: 0
    property int handsOnState: 0
    property int speedLimit: 30
    property bool speedLimitKnown: false

    readonly property int indicatorWidth: vw(20)
    readonly property int smallIndicatorWidth: vw(12)

    CaptionTextGauge {
        anchors {
            left: parent.left
            leftMargin: rowSpacing
        }
        width: smallIndicatorWidth
        height: parent.height
        caption: "MAX"
        value: speedLimit
        color: speedLimitKnown ? Colors.white : Colors.grey
    }

    SpeedIndicator {
        anchors {
            right: gearIndicator.left
        }
        width: indicatorWidth
        height: parent.height
    }

    Item {
        id: gearIndicator
        anchors {
            centerIn: parent
        }
        width: indicatorWidth
        height: parent.height
        visible: gear !== 0
        Rectangle {
            anchors {
                fill: prnd
                margins: vh(-2)
            }
            radius: 4
            color: {
                if (ebrStatus === 2 /* ACTUATING_DI_EBR */) {
                    return Colors.red
                }
                if (autopilotState === 3 /* ACTIVE_NOMINAL */) {
                    return Colors.blue
                }
                return  Colors.white
            }
        }
        Text {
            id: prnd
            anchors {
                centerIn: parent
                //offsetVertical: 10
            }
            text: {
                const gears = ["OFF", "P", "R", "N", "D", "", "", "OFF"]
                if (ebrStatus === 2 /* ACTUATING_DI_EBR */) {
                    return "HOLD"
                }
                if (autopilotState === 3 /* ACTIVE_NOMINAL */) {
                    return 'A'
                }
                return gears[gear]
            }
            font.pixelSize: vh(9)
            font.weight: Font.Bold
        }
    }

    PowerIndicator {
        id: powerIndicator
        anchors {
            left: gearIndicator.right
        }
        width: indicatorWidth
        height: parent.height
    }

    BatteryIndicator {
        anchors {
            right: parent.right
            rightMargin: rowSpacing
        }
        width: smallIndicatorWidth
        height: parent.height
    }

    Canbus {
        onUpdate: {
            gear = sig('DI_gear')

            // the ebr (emergency brake) status correlates to the car notion of
            // 'holding' while stopped
            ebrStatus = sig('ESP_ebrStatus')

            // auto pilot states
            autopilotState = sig('DAS_autopilotState')
            handsOnState = sig('DAS_autopilotHandsOnState')

            // speed limits
            const fusedLimit = sig('DAS_fusedSpeedLimit')
            if (fusedLimit !== 0 && fusedLimit !== 31 /* NONE */) {
                speedLimit = fusedLimit
                speedLimitKnown = true
            } else {
                speedLimitKnown = false
            }
        }
    }
}
