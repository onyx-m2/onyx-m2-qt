import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int soc: 0
    property int chargingLimit: 90
    property color gaugeColor: Colors.white

    Rectangle {
        id: backing
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            rightMargin: parent.width * 0.1
        }
        color: Colors.grey
    }

    Rectangle {
        id: tab
        anchors {
            verticalCenter: backing.verticalCenter
            left: backing.right
            right: parent.right
        }
        height: backing.height * 0.6
        color: soc > 90 ? Colors.white : Colors.grey
    }

    Rectangle {
        id: level
        anchors {
            top: backing.top
            //topMargin: backing.height * 0.1
            bottom: backing.bottom
            //bottomMargin: backing.height * 0.1
            left: backing.left
            right: backing.right
            rightMargin: parent.width * (90 - soc) / 100
        }
        height: backing.height
        color: gaugeColor
    }

    Text {
        anchors {
            right: backing.left
            bottom: backing.bottom
        }
        text: `${soc}% `
        color: gaugeColor
        font.pixelSize: backing.height * 1.1
        font.weight: Font.Medium
    }

    // CaptionTextGauge {
    //     anchors {
    //         fill: parent
    //     }
    //     value: soc
    //     caption: 'SOC'
    //     color: gaugeColor
    // }

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
