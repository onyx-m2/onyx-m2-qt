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
            suffix: 'PSI'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Front\nRight"
            value: fr
            suffix: 'PSI'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Rear\nLeft"
            value: rl
            suffix: 'PSI'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Rear\nRight"
            value: rr
            suffix: 'PSI'
        }
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
