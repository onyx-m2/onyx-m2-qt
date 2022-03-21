import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Components 1.0

// VAL_ 530 BMS_state 0 "STANDBY" 1 "DRIVE" 2 "SUPPORT" 3 "CHARGE" 4 "FEIM" 5 "CLEAR_FAULT" 6 "FAULT" 7 "WELD" 8 "TEST" 9 "SNA";
Item {
    id: app

    readonly property int rowSpacing: vh(5)
    readonly property int lineWidth: vh(0.6)

    function vh(pct) { return pct * height / 100 }
    function vw(pct) { return pct * width / 100 }

    property bool tripInProgress: false
    property real tripStartOdometer: 0
    property real tripStartDischarge: 0
    property real tripStartCharge: 0
    property int tripStartTime: 0

    Loader {
        id: display
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        //width: vw(100)
        height: vh(50)
    }

    Canbus {
        onUpdate: {
            const displayOn = sig('UI_displayOn')
            const gear = sig('DI_gear')
            const state = sig('BMS_state')
            if (!displayOn) {
                display.source = ''
            }
            else if (state === 3 /* CHARGE */) {
                display.source = 'ChargingDisplay.qml'
            }
            else if (gear === 0 || gear === 7 /* SNA */) {
                tripInProgress = false
                display.source = 'IdleDisplay.qml'
            }
            else {
                if (!tripInProgress) {
                    tripStartDischarge = sig('BMS_kwhDischargeTotal')
                    tripStartCharge = sig('BMS_kwhChargeTotal')
                    tripStartOdometer = sig('UI_odometer')
                    tripStartTime = sig('UTC_unixTime')
                    if (tripStartDischarge && tripStartCharge && tripStartOdometer && tripStartTime) {
                        tripInProgress = true
                    }
                }
                display.source = 'DrivingDisplay.qml'
            }
        }
    }
}
