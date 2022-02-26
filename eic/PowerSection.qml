import QtQuick 2.0
import Components 1.0

Item {
    property int frontRegen: 0
    property int frontPower: 0
    property int rearRegen: 0
    property int rearPower: 0
    property int driveMaxPower: 50
    property int regenMaxPower: 50

    readonly property int gagueOffset: lineWidth

    height: childrenRect.height

    LineGauge {
        id: frontRegenIndicator
        anchors {
            top: parent.top
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: gagueOffset
        }
        height: lineWidth
        value: frontRegen
        color: Colors.green
        maxValue: regenMaxPower
        state: 'reverse'
    }

    LineGauge {
        id: frontPowerIndicator
        anchors {
            top: parent.top
            left: parent.horizontalCenter
            leftMargin: gagueOffset
            right: parent.right
        }
        height: lineWidth
        value: frontPower
        maxValue: driveMaxPower
    }

    LineGauge {
        id: rearRegenIndicator
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: gagueOffset
            top: frontRegenIndicator.bottom
        }
        height: lineWidth
        value: rearRegen
        color: Colors.green
        maxValue: regenMaxPower
        state: 'reverse'
    }

    LineGauge {
        id: rearPowerIndicator
        anchors {
            left: parent.horizontalCenter
            leftMargin: gagueOffset//vw(1)
            right: parent.right
            top: frontPowerIndicator.bottom
        }
        height: lineWidth
        value:  rearPower
        maxValue: driveMaxPower
    }

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
        }
    }
}
