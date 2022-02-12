import QtQuick 2.0
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    property int speed: 0
    property int speedLimit: 0
    property color gaugeColor: Colors.white

    readonly property int withinSpeedLimit: 0
    readonly property int overSpeedLimit: 1
    readonly property int speedingOffense: 2
    readonly property int excessiveSpeedingOffense: 3

    TextGauge {
        anchors {
           fill: parent
        }
        value: speed
        units: 'km/h'
        color: gaugeColor
        state: 'rightAligned'
        //caption: 'MAX'
        //maxValue: speedLimit
        //state: 'reverse'
    }

    /**
    * Returns wether the car is currently speeding, and if so, how badly. There are
    * 3 tiers of speeding:
    *   - `overSpeedLimit`: Over the speed limit, but not enough to get a speeding ticket
    *   - `speedingOffense`: Over the speed limit by enough to get pulled over
    *   - `excessiveSpeedingOffense`: So far over the limit that excessive speeding laws
    *      kick in. Do not. EVer.
    *
    * The values for `speedingOffense` are empirical based on anecdotal experience in the
    * province of Quebec. USE AT YOUR OWN RISK!!! The values for excessive speeding are
    * taken from the SAAQ (https://saaq.gouv.qc.ca), and go like this:
    *   - 40 km/h or more in a zone where the speed limit is 60 km/h or less
    *   - 50 km/h or more in a zone where the speed limit is over 60 km/h and up to 90 km/h
    *   - 60 km/h or more in a zone where the speed limit is 100 km/h or over
    */
    function speedLimitStatus(speed, limit) {
        if (speed <= limit) {
            return withinSpeedLimit
        }
        const overLimit = speed - limit
        if (limit <= 60) {
            if (overLimit <= 10) {
                return overSpeedLimit
            }
            if (overLimit < 40) {
                return speedingOffense
            }
                return excessiveSpeedingOffense
        }
        if (limit <= 90) {
            if (overLimit <= 10) {
                return overSpeedLimit
            }
            if (overLimit < 50) {
                return speedingOffense
            }
            return excessiveSpeedingOffense
        }
        if (overLimit <= 20) {
            return overSpeedLimit
        }
        if (overLimit < 60) {
            return speedingOffense
        }
        return excessiveSpeedingOffense
    }

    Canbus {
        onUpdate: {
            speed = sig('DI_uiSpeed')

            // if the car knows the speed limit, use this as the max value of the
            // speed gauge
            var fusedLimit = sig('DAS_fusedSpeedLimit')
            if (fusedLimit !== 0 && fusedLimit !== 31 /* NONE */) {
                speedLimit = fusedLimit
            } else {
                speedLimit = 0
            }

            if (speedLimit > 0) {
                switch (speedLimitStatus(speed, speedLimit)) {
                    case overSpeedLimit:
                        gaugeColor = Colors.yellow
                        break
                    case speedingOffense:
                        gaugeColor = Colors.orange
                        break
                    case excessiveSpeedingOffense:
                        gaugeColor = Colors.red
                        break
                    default:
                        gaugeColor = Colors.white
                }
            } else {
                gaugeColor = Colors.white
            }
        }
    }

}
