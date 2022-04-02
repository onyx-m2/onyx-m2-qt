import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property real battTemp: 0
    property real brakeTemp: 0
    property real frontTemp: 0
    property real rearTemp: 0

    LongCaptionTextGauge {
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: parent.width / 10
            bottom: parent.verticalCenter
            bottomMargin: parent.height / 20
        }
        height: vh(6)
        caption: "Front Temp"
        value: frontTemp.toFixed(0)
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
        caption: "Rear Temp"
        value: rearTemp.toFixed(0)
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
        caption: "Battery Temp"
        value: battTemp.toFixed(0)
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
        caption: "Brake Temp"
        value: brakeTemp.toFixed(0)
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
