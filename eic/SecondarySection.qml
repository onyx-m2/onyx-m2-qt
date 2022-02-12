import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    property int drivePowerLimit: 0
    property int regenPowerLimit: 0
    property int drivetrainTemp: 0
    property real auxPower: 0
    property int expectedRange: 0
    property int idealRange: 0
    property int ratedConsumption: 0
    property int battTemp: 0

    readonly property int gaugeWidth: vw(12)

    RowLayout {
        anchors {
            fill: parent
        }
        height: parent.height
        spacing: rowSpacing

        CaptionTextGauge {
            id: regenGauge
            Layout.preferredWidth: gaugeWidth
            Layout.preferredHeight: parent.height
            // anchors {
            //     left: parent.left
            //     leftMargin: rowSpacing
            // }
            //width: gaugeWidth
            height: parent.height
            caption: "REGEN"
            value: regenPowerLimit
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.preferredHeight: parent.height
            caption: "DRIVE"
            value: drivePowerLimit
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.preferredHeight: parent.height
            caption: "TEMP"
            value: drivetrainTemp
        }

        Rectangle {
            Layout.preferredWidth: vw(0.4)
            Layout.preferredHeight: parent.height
            color: Colors.grey
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.preferredHeight: parent.height
            caption: "AUX"
            value: auxPower.toFixed(1)
        }

        Rectangle {
            Layout.preferredWidth: vw(0.3)
            Layout.preferredHeight: parent.height
            color: Colors.grey
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.preferredHeight: parent.height
            caption: "RANGE"
            value: expectedRange
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.preferredHeight: parent.height
            caption: "TRIP"
            value: ratedConsumption
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.preferredHeight: parent.height
            caption: "TEMP"
            value: battTemp
        }

    }

    Canbus {
        interval: 1000
        onUpdate: {
            drivePowerLimit = sig('DI_sysDrivePowerMax')
            regenPowerLimit = sig('DI_sysRegenPowerMax')
            const statorT = sig('DI_statorT')
            const inverterT = sig('DI_inverterT')
            drivetrainTemp = (statorT + inverterT) / 2

            const packVoltage = sig('BMS_packVoltage')
            const packCurrent = sig('BMS_packCurrent')
            const drivePower = sig('DI_elecPower')
            auxPower = Math.max(0, packVoltage * packCurrent / 1000 - drivePower)

            expectedRange = sig('UI_expectedRange')
            idealRange = sig('UI_idealRange')
            ratedConsumption = sig('UI_ratedConsumption')

            const minBattT = sig('BMS_thermistorTMin')
            const maxBattT =sig('BMS_thermistorTMax')
            battTemp = (maxBattT + minBattT) / 2
        }
    }
}
