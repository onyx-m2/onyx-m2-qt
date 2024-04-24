import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int expectedRange: 0
    property int ratedConsumption: 0
    property real tripDistance: 0
    property int tripDuration: 0
    property int tripConsumption: 0

    readonly property int gaugeWidth: vw(12)
    readonly property int gaugeSpacing: vw(1)

    function formatDuration(duration) {
        var seconds = duration % 60
        if (seconds < 10) {
            seconds = '0' + seconds
        }
        var minutes = Math.floor(duration / 60) % 60
        var hours =  Math.floor(duration / 3600)
        if (hours == 0) {
            return `${minutes}`
        }
        return `${hours}:${minutes}`
    }

    RowLayout {
        anchors.fill: parent

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Distance"
            value: tripDistance.toFixed(0)
            suffix: 'km'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Range"
            value: expectedRange
            suffix: 'km'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Efficiency"
            value: tripConsumption || ratedConsumption
            suffix: 'Wh/km'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Duration"
            value: formatDuration(tripDuration)
            suffix: tripDuration > 3600 ? 'hr' : 'min'
        }
    }

    Canbus {
        interval: 1000
        onUpdate: {
            expectedRange = sig('UI_expectedRange')
            ratedConsumption = sig('UI_ratedConsumption')

            const tripCharge = sig('BMS_kwhChargeTotal') - tripStartCharge
            const tripDischarge = sig('BMS_kwhDischargeTotal') - tripStartDischarge
            const tripEnergy = tripDischarge - tripCharge
            tripDistance = sig('UI_odometer') - tripStartOdometer
            if (tripDistance > 0) {
                tripConsumption = Math.round(tripEnergy * 1000 / tripDistance)
            }

            tripDuration = Date.now() / 1000 - tripStartTime
        }
    }
}
