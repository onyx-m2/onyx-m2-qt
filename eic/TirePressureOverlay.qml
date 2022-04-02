import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    readonly property real barToPsi: 14.5038
    property int fl: 0
    property int fr: 0
    property int rl: 0
    property int rr: 0

    LongCaptionTextGauge {
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: parent.width / 10
            bottom: parent.verticalCenter
            bottomMargin: parent.height / 20
        }
        height: vh(6)
        caption: "Front Left"
        value: fl
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
        caption: "Rear Left"
        value: rl
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
        caption: "Front Right"
        value: fr
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
        caption: "Rear Right"
        value: rr
    }

    Canbus {
        interval: 1000
        onUpdate: {
            fl = sig('TPMS_pressureFL') * barToPsi
            fr = sig('TPMS_pressureFR') * barToPsi
            rl = sig('TPMS_pressureRL') * barToPsi
            rr = sig('TPMS_pressureRR') * barToPsi
        }
    }
}
