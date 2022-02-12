import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    property int frontRegen: 0
    property int frontPower: 0
    property int rearRegen: 0
    property int rearPower: 0
    property int drivePowerLimit: 0
    property int regenPowerLimit: 0

    readonly property int gaugeHeight: rowSpacing / 2
    readonly property int gagueOffset: 4//rowSpacing / 2

    height: childrenRect.height

    LineGauge {
        id: frontRegenIndicator
        anchors {
            top: parent.top
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: gagueOffset//vw(1)
        }
        height: gaugeHeight
        value: frontRegen
        color: Colors.green
        maxValue: regenPowerLimit
        state: 'reverse'
    }

    LineGauge {
        id: frontPowerIndicator
        anchors {
            top: parent.top
            left: parent.horizontalCenter
            leftMargin: gagueOffset//vw(1)
            right: parent.right
        }
        //width: vw(48)
        height: gaugeHeight
        value: frontPower
        maxValue: drivePowerLimit
    }

    LineGauge {
        id: rearRegenIndicator
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: gagueOffset//vw(1)
            top: frontRegenIndicator.bottom
            topMargin: vh(-0.85)
        }
        height: gaugeHeight
        value: rearRegen
        color: Colors.green
        maxValue: regenPowerLimit
        state: 'reverse'
    }

    LineGauge {
        id: rearPowerIndicator
        anchors {
            left: parent.horizontalCenter
            leftMargin: gagueOffset//vw(1)
            right: parent.right
            top: frontPowerIndicator.bottom
            topMargin: vh(-0.85)
        }
        height: gaugeHeight
        value:  rearPower
        maxValue: drivePowerLimit
    }

    Canbus {
        onUpdate: {
            const elecPower = sig('DI_elecPower')
            if (elecPower < 0) {
                rearRegen = -elecPower
                rearPower = 0
            } else {
                rearPower = elecPower
                rearRegen = 0
            }
            const frontElecPower = sig('DI_frontElecPower')
            if (frontElecPower < 0) {
                frontRegen = -frontElecPower
                frontPower = 0
            } else {
                frontPower = frontElecPower
                frontRegen = 0
            }
            drivePowerLimit = sig('DI_sysDrivePowerMax')
            regenPowerLimit = sig('DI_sysRegenPowerMax')
        }
    }
}
