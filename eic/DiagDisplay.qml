import QtQuick 2.15
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property double tireSlip: 0

    GridLayout {
        anchors.fill: parent
        columns: 2

        // battery energy info
        // SignalGauge { name: 'BMS_initialFullPackEnergy' }
        // SignalGauge { name: 'BMS_nominalFullPackEnergy' }
        // SignalGauge { name: 'BMS_nominalEnergyRemaining' }
        // SignalGauge { name: 'BMS_idealEnergyRemaining' }
        // SignalGauge { name: 'BMS_energyBuffer' }
        // SignalGauge { name: 'BMS_expectedEnergyRemaining' }
        // SignalGauge { name: 'BMS_energyToChargeComplete' }

        // powertrain temps (not working currently)
        // SignalGauge { name: 'DI_inverterT' }
        // SignalGauge { name: 'DI_statorT' }
        // SignalGauge { name: 'DI_heatsinkT' }
        // SignalGauge { name: 'DI_inverterTpct' }
        // SignalGauge { name: 'DI_statorTpct' }
        // SignalGauge { name: 'DI_frontInverterT' }
        // SignalGauge { name: 'DI_frontStatorT' }
        // SignalGauge { name: 'DI_frontHeatsinkT' }
        // SignalGauge { name: 'DI_frontInverterTpct' }
        // SignalGauge { name: 'DI_frontStatorTpct' }

        // cooling info
        // SignalGauge { name: 'VCFRONT_tempCoolantBatInlet' }
        // SignalGauge { name: 'VCFRONT_tempCoolantPTInlet' }
        // SignalGauge { name: 'VCFRONT_coolantFlowBatActual' }
        // SignalGauge { name: 'VCFRONT_coolantFlowBatTarget' }
        // SignalGauge { name: 'VCFRONT_coolantFlowBatReason' }
        // SignalGauge { name: 'VCFRONT_coolantFlowPTActual' }
        // SignalGauge { name: 'VCFRONT_coolantFlowPTTarget' }
        // SignalGauge { name: 'VCFRONT_coolantFlowPTReason' }

        SignalGauge { name: 'BMS_packVoltage' }
        SignalGauge { name: 'BMS_packCurrent' }

        // SignalGauge { name: 'UI_tripPlanningActive' }
        // SignalGauge { name: 'UI_energyAtDestination' }
        // SignalGauge { name: 'UI_timeToDestination' }

        SignalGauge { name: 'BMS_thermistorTMin' }
        SignalGauge { name: 'BMS_thermistorTMax' }

        // ac charging info        
        // SignalGauge { name: 'UI_chargeTerminationPct' }
        // SignalGauge { name: 'CC_line1Voltage' }
        // SignalGauge { name: 'UI_acChargeCurrentLimit' }
        // SignalGauge { name: 'BMS_energyToChargeComplete' }
        // SignalGauge { name: 'CP_pilotCurrent' }
        // SignalGauge { name: 'BMS_chgTimeToFull' }
        // SignalGauge { name: 'BMS_acChargerKwhTotal' }
        
        // dc charging info
        // SignalGauge { name: 'BMS_dcChargerKwhTotal' }
        // SignalGauge { name: 'CP_evseOutputDcCurrent' }
        // SignalGauge { name: 'CP_evseOutputDcVoltage' }

        // driving dynamics
        // SignalGauge { name: 'ESP_brakeTorqueFL' }
        // SignalGauge { name: 'ESP_brakeTorqueRL' }
        SignalGauge { name: 'ESP_wheelAngleFL' }
        SignalGauge { name: 'ESP_wheelSpeedFL' }
        SignalGauge { name: 'ESP_wheelAngleRL' }
        SignalGauge { name: 'ESP_wheelAngleRR' }
        SignalGauge { name: 'DI_axleSpeed' }
        SignalGauge { name: 'DIS_frontAxleSpeed' }
        
        
        
    }

        Text {
            text: 'slip: ' + tireSlip
            color: 'white'
        }

    property double lastTime: 0
    property double lastWheelAngleFL: 0
    readonly property double wheelDiameter: 0.66802 // 26.3" in meters
    Canbus {
        onUpdate: {
            const wheelSpeed = Math.PI * wheelDiameter * sig('ESP_wheelSpeedFL') * 60 / 1000
            const vehicleSpeed = sig('ESP_vehicleSpeed')
            tireSlip = sig('ESP_wheelSpeedFL') / sig('DIS_frontAxleSpeed')
            // const currentAngle = sig('ESP_wheelAngleFL')
            // const currentTime = Date.now()
            // if (lastTime !== 0) {
            //     const interval = currentTime - lastTime  
            //     const angleDelta = currentAngle - lastWheelAngleFL
            //     const wheelRotationSpeed = 2 * Math.PI * wheelRadius * angleDelta / interval / 180 / 1000 * 1000 * 60 * 60
            //     tireSlip = wheelRotationSpeed

            //     const vehicleSpeed = ('ESP_vehicleSpeed')

            // }
            // lastWheelAngleFL = currentAngle
            // lastTime = currentTime
            // //tireSlip = sig('ESP_wheelAngleFL') - sig('ESP_vehicleSpeed') 
        }
    }
}
