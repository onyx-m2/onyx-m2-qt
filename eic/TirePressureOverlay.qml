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

    RowLayout {
        anchors.fill: parent

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Front\nLeft"
            value: fl
            suffix: 'psi'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Front\nRight"
            value: fr
            suffix: 'psi'
        }

        Item {
            width: vw(40)
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Rear\nLeft"
            value: rl
            suffix: 'psi'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Rear\nRight"
            value: rr
            suffix: 'psi'
        }
    }

    Canbus {
        interval: 1000
        onUpdate: {
            fl = Math.round(sig('TPMS_btPressureFL') * barToPsi)
            fr = Math.round(sig('TPMS_btPressureFR') * barToPsi)
            rl = Math.round(sig('TPMS_btPressureRL') * barToPsi)
            rr = Math.round(sig('TPMS_btPressureRR') * barToPsi)
        }
    }
}
