import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int soc: 0
    property color gaugeColor: Colors.white

    CaptionTextGauge {
        anchors {
            fill: parent
        }
        value: soc
        caption: 'SOC'
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
        }
    }

}
