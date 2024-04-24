import QtQuick 2.15
import Components 1.0

Item {
    property string clock: ''
    property real odometer: 0
    property int capacity: 0

    BatteryIndicator {
        anchors {
            top: parent.top
            right: parent.right
        }
        width: vw(7)
        height: vh(5)
    }

    Text {
        anchors {
            left: parent.left
            bottom : parent.bottom
            bottomMargin: vh(4)
        }
        text: clock
        color: Colors.white
        font.pixelSize: vh(6)
    }

    Text {
        id: odometerText
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin: vh(4)
        }
        text: `${odometer.toFixed().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")} km`//`${soc} %`
        color: Colors.white
        font.pixelSize: vh(6)
    }

    Text {
        anchors {
            right: parent.right
            bottom : parent.bottom
            bottomMargin: vh(4)
        }
        text: `${capacity} %`
        color: Colors.white
        font.pixelSize: vh(6)
    }

    Item {
        id: topSection
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: odometerText.top
        }

        Image {
            id: logo
            anchors {
                centerIn: parent
            }
            sourceSize.width: parent.width
            fillMode: Image.PreserveAspectFit
            source: 'assets/silhouette.png'
        }
    }

    Timer {
        triggeredOnStart: true
        interval: 1000
        running: true 
        repeat: true
        onTriggered: {
            clock = (new Date()).toLocaleTimeString(Qt.locale('en_US'), Locale.ShortFormat).toLocaleLowerCase()
        }
    }

    Canbus {
        interval: 1000
        onUpdate: {
            odometer = sig('UI_odometer')

            // battery capacity (i.e. opposite of "degradation")
            const nominalFullPack = sig('BMS_nominalFullPackEnergy')
            const initialFullPack = sig('BMS_initialFullPackEnergy')
            if (nominalFullPack !== 0 && initialFullPack !== 0) {
                capacity = nominalFullPack * 100 / initialFullPack
            }
        }
    }
}
