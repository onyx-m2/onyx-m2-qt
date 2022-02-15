import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    property int soc: 0
    property int chargingLimit: 90
    property color gaugeColor: Colors.white

    CaptionTextGauge {
        anchors {
            fill: parent
        }
        value: soc
        caption: 'Battery'
        color: gaugeColor
    }

    Canbus {
        onUpdate: {
            soc = sig('UI_usableSOC')

            // display the gauge using the same color scheme as the car goes for
            // low battery states
            if (soc <= 5) {
                gaugeColor = Colors.red
            }
            else if (soc <= 20) {
                gaugeColor = Colors.yellow
            }
            else {
                gaugeColor = Colors.white
            }

            // calculate the charging limit to display as the max value of the battery
            // gauge
            const nominalFullPackEnergy = sig('BMS_nominalFullPackEnergy')
            const nominalEnergyRemaining = sig('BMS_nominalEnergyRemaining')
            const energyToChargeComplete = sig('BMS_energyToChargeComplete')
            if (nominalFullPackEnergy !== 0) {
                chargingLimit = (energyToChargeComplete + nominalEnergyRemaining) / nominalFullPackEnergy * 100
            }
        }
    }

}
