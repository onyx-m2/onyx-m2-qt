import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Theme 1.0
import Gauges 1.0

// VAL_ 530 BMS_state 0 "STANDBY" 1 "DRIVE" 2 "SUPPORT" 3 "CHARGE" 4 "FEIM" 5 "CLEAR_FAULT" 6 "FAULT" 7 "WELD" 8 "TEST" 9 "SNA";
Item {
    id: app

    readonly property int rowSpacing: vh(4)
    function vh(pct) { return pct * height / 100 }
    function vw(pct) { return pct * width / 100 }

    property real timestamp: 0

    Loader {
        id: display
        width: vw(100)
        height: vh(50)
    }

    // time code indicator (debug)
    Rectangle {
        anchors {
            top: display.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: Colors.grey
        Text {
            anchors {
                right: parent.right
                bottom: parent.bottom
            }
            text: timestamp
            font.pixelSize: vh(5)
        }
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
                display.source = 'IdleDisplay.qml'
            }
            else {
                display.source = 'DrivingDisplay.qml'
            }
            timestamp = canbus.timestamp()//sig('UTC_seconds') //
        }
    }
}
