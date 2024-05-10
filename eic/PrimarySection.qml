import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    //color: 'blue'
    property int gear: 7 // SNA
    //property int ebrStatus: 0
    property int autopilotState: 0
    property int handsOnState: 0
    property int steeringAngle: 0
    property int speedLimit: 30
    property bool speedLimitKnown: false

    readonly property int indicatorWidth: vw(20)
    readonly property int smallIndicatorWidth: vw(12)

    SpeedLimitIndicator {
        id: speedLimitIndicator
        anchors {
            right: parent.right
            //leftMargin: rowSpacing
            //horizontalCenter: parent.horizontalCenter
            //verticalCenter: parent.verticalCenter
            top: parent.top
        }
        width: vw(12)
        height: vh(26)
    }

    SpeedIndicator {
        anchors {
            left: parent.left
            //leftMargin: parent.width / 10
            //right: parent.horizontalCenter
            //horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        //width: vw(50)
        height: vh(28)
    }

    // Text {
    //     id: gearIndicator
    //     anchors {
    //         horizontalCenter: parent.horizontalCenter
    //         bottom: parent.verticalCenter
    //     }
    //     text: {
    //         const gears = ["", "P", "R", "N", "D", "", "", ""]
    //         // if (ebrStatus === 2 /* ACTUATING_DI_EBR */) {
    //         //     return "H"
    //         // }
    //         // if (autopilotState === 3 /* ACTIVE_NOMINAL */) {
    //         //     return 'A'
    //         // }
    //         return gears[gear]
    //     }
    //     horizontalAlignment: Text.AlignHCenter
    //     font.pixelSize: vh(18)
    //     //font.weight: Font.Thin
    //     color: Colors.white
    //     width: vw(8)
    // }

    // Item {
    //     anchors {
    //         horizontalCenter: parent.horizontalCenter
    //         top: parent.verticalCenter
    //     }
    //     width: vw(7)
    //     height: vh(18)
    //     // Layout.preferredWidth: gaugeWidth
    //     // Layout.fillHeight: true
    //     // Layout.alignment: Qt.AlignCenter

    //     Image {
    //         anchors.fill: parent
    //         sourceSize.width: vw(7)
    //         fillMode: Image.PreserveAspectFit
    //         source: {
    //             // if (ebrStatus === 2 /* ACTUATING_DI_EBR */) {
    //             //     return 'assets/hold.png'
    //             // }
    //             if (autopilotState === 2 /* AVAILABLE */ || autopilotState === 3 /* ACTIVE_NOMINAL */) {
    //                 return 'assets/steering-wheel.png'
    //             }
    //             return ''
    //         }
    //         smooth: true
    //         transformOrigin: Item.Center
    //         rotation: steeringAngle
    //         layer {
    //             enabled: true
    //             effect: ColorOverlay {
    //                 color: {
    //                     // if (ebrStatus === 2 /* ACTUATING_DI_EBR */) {
    //                     //     return Colors.red
    //                     // }
    //                     if (autopilotState === 3 /* ACTIVE_NOMINAL */) {
    //                         return Colors.blue
    //                     }
    //                     return Colors.grey
    //                 }

    //             }
    //         }
    //     }
    // }

    // PowerIndicator {
    //     id: powerIndicator
    //     anchors {
    //         left: parent.horizontalCenter
    //         right: parent.right//batteryIndicator.left
    //         //rightMargin: parent.width / 8
    //         verticalCenter: parent.verticalCenter
    //     }
    //     //width: indicatorWidth
    //     height: vh(28)
    // }

    // BatteryIndicator {
    //     id: batteryIndicator
    //     anchors {
    //         right: parent.right
    //         rightMargin: rowSpacing
    //     }
    //     width: vw(9)
    //     height: vh(19)
    // }

    Canbus {
        onUpdate: {
            gear = sig('DI_gear')

            // the ebr (emergency brake) status correlates to the car notion of
            // 'holding' while stopped
            //ebrStatus = sig('ESP_ebrStatus')

            // auto pilot states
            autopilotState = sig('DAS_autopilotState')
            handsOnState = sig('DAS_autopilotHandsOnState')
            steeringAngle = sig('SCCM_steeringAngle')

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
