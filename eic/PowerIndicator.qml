import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int power: 0
    property color gaugeColor: Colors.white

    TextGauge {
        anchors {
            fill: parent
        }
        value: power
        units: 'KW'
        color: gaugeColor
    }

    Canbus {
        onUpdate: {
            const elecPower = sig('DI_elecPower')
            const frontElecPower = sig('DI_frontElecPower')
            power = elecPower + frontElecPower
            if (power < 0) {
                power = -power
                gaugeColor = Colors.green
            } else {
                gaugeColor = Colors.white
            }
        }
    }
}
