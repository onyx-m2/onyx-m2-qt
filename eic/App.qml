import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Components 1.0

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
        focus: true
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.verticalCenter
            bottomMargin: -70
        }
    }
    Rectangle {
        anchors {
            top: display.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: 'black'
    }

    Canbus {
        onUpdate: {
            const leftButtonPressed = sig('VCLEFT_swcLeftPressed')
            const rightButtonPressed = sig('VCLEFT_swcRightPressed')
            if (leftButtonPressed === 2 /* BUTTON_ON */ && rightButtonPressed === 2 /* BUTTON_ON */) {
                Qt.callLater(Qt.quit)
            }

            const displayOn = sig('UI_displayOn')
            const gear = sig('DI_gear')
            const state = sig('BMS_state')
            const trackMode = sig('DI_trackModeState')
            const diagMode = sig('UI_childDoorLockOn') // use "child lock" to show diags
            if (!displayOn) {
                display.source = ''
            }
            else if (diagMode === 1) {
                display.source = 'DiagDisplay.qml'
            }
            else if (state === 3 /* CHARGE */) {
                display.source = 'ChargingDisplay.qml'
            }
            else if (gear === 0 || gear === 7 /* SNA */) {
                tripInProgress = false
                display.source = 'IdleDisplay.qml'
            }
            else if (trackMode === 2 /* ON */) {
                display.source = 'TrackDisplay.qml'
            }
            else {
                if (!tripInProgress) {
                    tripStartDischarge = sig('BMS_kwhDischargeTotal')
                    tripStartCharge = sig('BMS_kwhChargeTotal')
                    tripStartOdometer = sig('UI_odometer')
                    tripStartTime = Date.now() / 1000
                    if (tripStartDischarge && tripStartCharge && tripStartOdometer && tripStartTime) {
                        tripInProgress = true
                    }
                }
                display.source = 'DrivingDisplay.qml'
            }
        }
    }
}
