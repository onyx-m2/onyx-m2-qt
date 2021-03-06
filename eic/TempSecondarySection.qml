import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int drivePowerLimit: 0
    property int regenPowerLimit: 0
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

        Rectangle {
            Layout.preferredWidth: vw(0.4)
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
            caption: tripConsumption ? "Trip" : "Rated"
            value: tripConsumption || ratedConsumption
        }

        Image {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            sourceSize.width: gaugeWidth
            fillMode: Image.PreserveAspectFit
            source: 'assets/road.png'
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Aux"
            value: auxPower.toFixed(1)
        }

        CaptionTextGauge {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            caption: "Temp"
            value: battTemp
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
            caption: "Drive"
            value: drivePowerLimit
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

            const tripCharge = sig('BMS_kwhChargeTotal') - tripStartCharge
            const tripDischarge = sig('BMS_kwhDischargeTotal') - tripStartDischarge
            const tripEnergy = tripDischarge - tripCharge
            const tripDistance = sig('UI_odometer') - tripStartOdometer
            if (tripDistance > 0) {
                tripConsumption = Math.round(tripEnergy * 1000 / tripDistance)
            }
        }
    }
}
