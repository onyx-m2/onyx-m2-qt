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
    property int tripConsumption: 0
    property int battTemp: 0

    readonly property int gaugeWidth: vw(12)
    readonly property int gaugeSpacing: vw(1)

    RowLayout {
        anchors {
            fill: parent
        }
        height: parent.height
        spacing: gaugeSpacing

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            height: parent.height
            caption: "Regen"
            value: regenPowerLimit
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Drive"
            value: drivePowerLimit
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Temp"
            value: drivetrainTemp
        }

        Rectangle {
            Layout.preferredWidth: vw(0.4)
            //Layout.preferredHeight: parent.height
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            color: Colors.grey
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Aux"
            value: auxPower.toFixed(1)
        }

        Rectangle {
            Layout.preferredWidth: vw(0.3)
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            color: Colors.grey
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Range"
            value: expectedRange
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Trip"
            value: tripConsumption || ratedConsumption
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Temp"
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

            const odometer = sig('UI_odometer')
            const energy = sig('BMS_nominalEnergyRemaining')
            const tripDistance = odometer - tripStartOdometer
            if (tripDistance > 0) {
                tripConsumption = (tripStartEnergy - energy) * 1000 / tripDistance
            }
        }
    }
}
