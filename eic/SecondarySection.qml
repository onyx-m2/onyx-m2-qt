import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int drivePowerLimit: 0
    property int regenPowerLimit: 0
    property real auxPower: 0
    property int expectedRange: 0
    property int ratedConsumption: 0
    property int tripConsumption: 0
    property int battTemp: 0
    property int ebrStatus: 0
    property int autopilotState: 0
    property int handsOnState: 0

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

        // Rectangle {
        //     Layout.preferredWidth: vw(0.3)
        //     Layout.fillHeight: true
        //     Layout.alignment: Qt.AlignCenter
        //     color: Colors.grey
        // }

        Item {
            Layout.preferredWidth: gaugeWidth
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter

            Image {
                anchors.fill: parent
                sourceSize.width: gaugeWidth
                fillMode: Image.PreserveAspectFit
                source: {
                    if (ebrStatus === 2 /* ACTUATING_DI_EBR */) {
                        return 'assets/hold.png'
                    }
                    if (autopilotState === 2 /* AVAILABLE */ || autopilotState === 3 /* ACTIVE_NOMINAL */) {
                        return 'assets/steering-wheel.png'
                    }
                    return ''
                }
                smooth: true
                layer {
                    enabled: true
                    effect: ColorOverlay {
                        color: {
                            if (ebrStatus === 2 /* ACTUATING_DI_EBR */) {
                                return Colors.red
                            }
                            if (autopilotState === 3 /* ACTIVE_NOMINAL */) {
                                return Colors.blue
                            }
                            return Colors.grey
                        }

                    }
                }
            }

        }

        // Rectangle {
        //     Layout.preferredWidth: vw(0.3)
        //     Layout.fillHeight: true
        //     Layout.alignment: Qt.AlignCenter
        //     color: Colors.grey
        // }

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

            const packVoltage = sig('BMS_packVoltage')
            const packCurrent = sig('BMS_packCurrent')
            const frontDrivePower = sig('DI_frontElecPower')
            const rearDrivePower = sig('DI_elecPower')
            auxPower = Math.max(0, packVoltage * packCurrent / 1000 - rearDrivePower - frontDrivePower)

            expectedRange = sig('UI_expectedRange')
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

            // the ebr (emergency brake) status correlates to the car notion of
            // 'holding' while stopped
            ebrStatus = sig('ESP_ebrStatus')

            // auto pilot states
            autopilotState = sig('DAS_autopilotState')
            handsOnState = sig('DAS_autopilotHandsOnState')
        }
    }
}
