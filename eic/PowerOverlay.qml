import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int frontElecPower: 0
    property int elecPower: 0
    property int drivePowerLimit: 0
    property int regenPowerLimit: 0

    RowLayout {
        anchors.fill: parent

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Max\nRegen"
            value: regenPowerLimit
            suffix: 'KW'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Front\nPower"
            value: frontElecPower
            suffix: 'KW'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Rear\nPower"
            value: elecPower
            suffix: 'KW'
        }

        LongCaptionTextGauge {
            Layout.fillWidth: true
            Layout.fillHeight: true
            caption: "Max\nDrive"
            value: drivePowerLimit
            suffix: 'KW'
        }
    }

    Canbus {
        onUpdate: {
          elecPower = sig('DI_elecPower')
          frontElecPower = sig('DI_frontElecPower')
          drivePowerLimit = sig('DI_sysDrivePowerMax')
          regenPowerLimit = sig('DI_sysRegenPowerMax')
        }
    }
}
