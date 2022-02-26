import QtQuick 2.15
import Components 1.0

Item {
    property string time: ''
    property real odometer: 0
    property int soc: 0
    property int temp: 0
    property int capacity: 0
    readonly property int indicatorWidth: vw(35)
    readonly property int indicatorHeight: vh(18)

    Text {
        anchors {
            left: parent.left
            bottom : parent.bottom
        }
        text: time
        color: Colors.white
        font.pixelSize: vh(6)
    }

    Text {
        id: socText
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom : parent.bottom
        }
        text: `${odometer.toFixed().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")} km`//`${soc} %`
        color: Colors.white
        font.pixelSize: vh(6)
}

    Text {
        anchors {
            right: parent.right
            bottom : parent.bottom
        }
        text: `${capacity} %` //${temp} °c`
        color: Colors.white
        font.pixelSize: vh(6)
}

    Rectangle {
        id: separator
        anchors {
            left: parent.left
            right: parent.right
            top: socText.top
            topMargin: -rowSpacing
        }
        color: Colors.black
        height: vh(0.1)
    }

    Item {
        id: topSection
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: separator.top
        }

        Image {
            id: logo
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            sourceSize.height: parent.height
            fillMode: Image.PreserveAspectFit
            source: 'assets/silhouette.png'
        }
    }

    Canbus {
        interval: 1000
        onUpdate: {
            odometer = sig('UI_odometer')
            soc = sig('UI_usableSOC')

            time = new Date().toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit'
            }).toLocaleLowerCase()

            // battery capacity (i.e. opposite of "degradation")
            const nominalFullPack = sig('BMS_nominalFullPackEnergy')
            const initialFullPack = sig('BMS_initialFullPackEnergy')
            if (nominalFullPack !== 0 && initialFullPack !== 0) {
                capacity = nominalFullPack * 100 / initialFullPack
            }
        }
    }
}
