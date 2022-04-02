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
            return `${minutes}:${seconds}`
        }
        return `${hours}:${minutes}:${seconds}`
    }

    LongCaptionTextGauge {
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: parent.width / 10
            bottom: parent.verticalCenter
            bottomMargin: parent.height / 20
        }
        height: vh(6)
        caption: "Distance"
        value: tripDistance.toFixed(1)
    }

    LongCaptionTextGauge {
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: parent.width / 10
            top: parent.verticalCenter
            topMargin: parent.height / 20
        }
        height: vh(6)
        caption: "Range"
        value: expectedRange
    }

    LongCaptionTextGauge {
        anchors {
            left: parent.horizontalCenter
            leftMargin: parent.width / 10
            right: parent.right
            bottom: parent.verticalCenter
            bottomMargin: parent.height / 20
        }
        height: vh(6)
        caption: "Energy"
        value: tripConsumption || ratedConsumption
    }

    LongCaptionTextGauge {
        anchors {
            left: parent.horizontalCenter
            leftMargin: parent.width / 10
            right: parent.right
            top: parent.verticalCenter
            topMargin: parent.height / 20
        }
        height: vh(6)
        caption: "Duration"
        value: formatDuration(tripDuration)
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
