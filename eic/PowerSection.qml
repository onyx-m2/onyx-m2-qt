import QtQuick 2.0
import Components 1.0

Item {
    property int frontRegen: 0
    property int frontPower: 0
    property int rearRegen: 0
    property int rearPower: 0
    property int driveMaxPower: 50
    property int regenMaxPower: 50
    property int drivePowerLimit: 0
    property int regenPowerLimit: 0

    readonly property int gagueOffset: 0//lineWidth
    readonly property int gagueLineHeight: lineWidth * 2

    width: parent.width
    height: lineWidth * 3

    LineGauge {
        id: frontRegenIndicator
        anchors {
            top: parent.top
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: gagueOffset
        }
        height: gagueLineHeight
        value: frontRegen
        color: Colors.green
        maxValue: regenMaxPower
        state: 'reverseLabelAbove'
    }

    Rectangle {
        anchors {
            verticalCenter: parent.verticalCenter
            //top: frontRegenIndicator.bottom
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: gagueOffset
            //bottom: rearRegenIndicator.top
        }
        height: lineWidth
        color: Colors.grey
    }

    LineGauge {
        id: rearRegenIndicator
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: gagueOffset
            bottom: parent.bottom
        }
        height: gagueLineHeight
        value: rearRegen
        color: Colors.green
        maxValue: regenMaxPower
        state: 'reverse'
    }

    // Text {
    //     anchors {
    //         left: parent.left
    //         bottom: rearRegenIndicator.top
    //         bottomMargin: vh(1)
    //     }
    //     color: Colors.grey
    //     text: regenPowerLimit
    //     font.pixelSize: vh(6)
    // }

    LineGauge {
        id: frontPowerIndicator
        anchors {
            top: parent.top
            left: parent.horizontalCenter
            leftMargin: gagueOffset
            right: parent.right
        }
        height: gagueLineHeight
        value: frontPower
        maxValue: driveMaxPower
        state: 'labelAbove'
    }

    Rectangle {
        anchors {
            verticalCenter: parent.verticalCenter
            //top: frontPowerIndicator.bottom
            left: parent.horizontalCenter
            leftMargin: gagueOffset
            right: parent.right
            //bottom: rearPowerIndicator.top
        }
        height: lineWidth
        color: Colors.grey
    }

    LineGauge {
        id: rearPowerIndicator
        anchors {
            left: parent.horizontalCenter
            leftMargin: gagueOffset
            right: parent.right
            bottom: parent.bottom
        }
        height: gagueLineHeight
        value:  rearPower
        maxValue: driveMaxPower
    }

    // Text {
    //     anchors {
    //         right: parent.right
    //         bottom: rearPowerIndicator.top
    //         bottomMargin: vh(1)
    //     }
    //     color: Colors.grey
    //     text: drivePowerLimit
    //     font.pixelSize: vh(6)
    // }

    // Rectangle {
    //     anchors {
    //         top: rearPowerIndicator.top
    //         left: rearPowerIndicator.left
    //         leftMargin: rearPowerIndicator.length
    //     }
    //     width: vw(6)
    //     height: vh(6)
    //     Text {
    //         text: rearPower
    //         font.pixelSize: vh(6)
    //         horizontalAlignment: Text.AlignRight
    //     }
    //     color: Colors.white
    //     visible: rearPower != 0
    // }

    Canbus {
        onUpdate: {
            const elecPower = sig('DI_elecPower')
            if (elecPower < 0) {
                rearPower = 0
                rearRegen = -elecPower
                if (rearRegen > regenMaxPower) {
                    regenMaxPower = rearRegen
                }
            } else {
                rearRegen = 0
                rearPower = elecPower
                if (rearPower > driveMaxPower) {
                    driveMaxPower = rearPower
                }
            }
            const frontElecPower = sig('DI_frontElecPower')
            if (frontElecPower < 0) {
                frontPower = 0
                frontRegen = -frontElecPower
                if (frontRegen > regenMaxPower) {
                    regenMaxPower = frontRegen
                }
            } else {
                frontRegen = 0
                frontPower = frontElecPower
                if (frontPower > driveMaxPower) {
                    driveMaxPower = frontPower
                }
            }
            drivePowerLimit = sig('DI_sysDrivePowerMax')
            regenPowerLimit = sig('DI_sysRegenPowerMax')
        }
    }
}
