import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property real battTemp: 0
    property real brakeTemp: 0
    property real frontTemp: 0
    property real rearTemp: 0

    RowLayout {
        anchors.fill: parent

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Front\nPowertrain"
            value: frontTemp.toFixed(0)
            suffix: '°c'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Rear\nPowertrain"
            value: rearTemp.toFixed(0)
            suffix: '°c'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Battery\nTemp"
            value: battTemp.toFixed(0)
            suffix: '°c'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Brakes\nTemp"
            value: brakeTemp.toFixed(0)
            suffix: '°c'
        }
    }

    Canbus {
        interval: 1000
        onUpdate: {
            const minBattT = sig('BMS_thermistorTMin')
            const maxBattT = sig('BMS_thermistorTMax')
            battTemp = (maxBattT + minBattT) / 2

            brakeTemp = (
                sig('DI_brakeFLTemp') +
                sig('DI_brakeFRTemp') +
                sig('DI_brakeRLTemp') +
                sig('DI_brakeRRTemp')
            ) / 4

            frontTemp = (
                sig('DI_frontInverterT') +
                sig('DI_frontStatorT')
            ) / 2

            rearTemp = (
                sig('DI_inverterT') +
                sig('DI_statorT')
            ) / 2
        }
    }
}
