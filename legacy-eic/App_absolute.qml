import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import Theme 1.0

Item {
    id: app
    width: 1980
    height: 1080
    readonly property int clusterLineWidth: 5
    readonly property int separatorLineWidth: 2
    readonly property int gaugeBarWidth: 30

    property string odometer
    property string capacity
    property string speed

    transform: [
        Translate { x: 1980 / 2; y: 1080 / 2 + 4 * 1080 / 100},
        Scale { xScale: app.width / 1980; yScale: app.height / 1080 }
    ]

//    Timer {
//        interval: 16;
//        running: true
//        repeat: true
//        onTriggered: {
//            speed = canbus.signal('DI_uiSpeed').toLocaleString(Qt.locale('us_EN'), 'f', 0)
//            odometer = canbus.signal('UI_odometer').toLocaleString(Qt.locale('us_EN'), 'f', 2)
//            var nominalFullPack = canbus.signal('BMS_nominalFullPack')
//            var initialFullPack = canbus.signal('BMS_initialFullPack')
//            if (nominalFullPack !== 0 && initialFullPack !== 0) {
//                const value = nominalFullPack * 100 / initialFullPack
//                capacity = value.toLocaleString(Qt.locale('us_EN'), 'f', 0) + '%'
//            }
//        }
//    }

    Shape {
        id: shape
        //transform: Translate { x: shape.width / 2; y: shape.height / 2 + 4 * shape.height / 100}
        width: parent.width
        height: parent.width / 2

        // separator
        ShapePath {
            scale: Qt.size(1980 / 200, 1080 / 100)
            strokeWidth: separatorLineWidth
            strokeColor: Theme.primary
            fillColor: 'transparent'
            PathSvg {
                path: 'M -100 40 h 56
                      c 6 0, 6 5, 12 5
                      h 64
                      c 6 0, 6 -5, 12 -5
                      h 56'
            }
        }

        // left cluster
        ShapePath {
            scale: Qt.size(1980 / 200, 1080 / 100)
            strokeWidth: clusterLineWidth
            strokeColor: Theme.primary
            fillColor: 'transparent'
            PathMove { x: -46; y: 60 / 2 }
            PathLine { x: -88; y: 60 / 2 }
            PathArc { radiusX: -88; radiusY: -88; x: -88; y: -60 / 2 }
            PathLine { x: -46; y: -60 / 2 }
        }
        ShapePath {
            scale: Qt.size(1980 / 200, 1080 / 100)
            strokeWidth: gaugeBarWidth
            strokeColor: 'grey'
            strokeStyle: ShapePath.DashLine
            dashPattern: [1, 2]
            fillColor: 'transparent'
            PathMove { x: -92; y: 60 / 2 }
            PathArc { radiusX: -96; radiusY: -96; x: -92; y: - 60 / 2 }
        }

        // right cluster
        ShapePath {
            scale: Qt.size(1980 / 200, 1080 / 100)
            strokeWidth: clusterLineWidth
            strokeColor: Theme.primary
            fillColor: 'transparent'
            PathMove { x: 46; y: - 60 / 2 }
            PathLine { x: 88; y: - 60 / 2 }
            PathArc { radiusX: 88; radiusY: 88; x: 88; y: 60 / 2 }
            PathLine { x: 46; y: 60 / 2 }
        }
        ShapePath {
            scale: Qt.size(1980 / 200, 1080 / 100)
            strokeWidth: gaugeBarWidth
            strokeColor: 'grey'
            //strokeStyle: ShapePath.DashLine
            fillColor: 'transparent'
            PathMove { x: 92; y: 60 / 2 }
            PathArc { direction: PathArc.Counterclockwise; radiusX: 96; radiusY: 96; x: 92; y: - 60 / 2 }
        }

        // center cluster
        ShapePath {
            scale: Qt.size(shape.width / 200, shape.height / 100)
            strokeWidth: clusterLineWidth
            strokeColor: Theme.primary
            fillColor: 'transparent'
            PathMove { x: -24; y: 40 }
            PathArc { useLargeArc: true;  radiusX: 46.5; radiusY: 46.5; x: 24; y: 40 }
            PathLine { x: -24; y: 40 }
        }

    }

    Item {

        // banner
        Shape {
            id: banner
            ShapePath {
                scale: Qt.size(shape.width / 200, shape.height / 100)
                strokeColor: 'transparent'
                fillGradient: LinearGradient {
                    x1: -400
                    y1: 0
                    x2: 400
                    y2: 0
                    GradientStop { position: 0.0; color: "black" }
                    //GradientStop { position: 0.5; color: Theme.highlight }
                    GradientStop { position: 0.5; color: Colors.red }
                    GradientStop { position: 1.0; color: "black" }
                }
                //fillColor: Theme.highlight
                PathMove { x: -42; y: -6 }
                PathLine { x: 42; y: -6 }
                PathLine { x: 42; y: -6 + 15 }
                PathLine { x: -42; y: -6 + 15 }
            }
        }

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 18
            font.pointSize: 70
            font.weight: Font.ExtraBold
            //anchors.horizontalCenter: parent.horizontalCenter
            //horizontalAlignment: Text.AlignHCenter
            color: 'black'
            text: "BRAKING"
        }
    }


    Text {
        x: -12
        y: -12
        font.pixelSize: 140
        font.weight: Font.Light
        //anchors.horizontalCenter: parent.horizontalCenter
        //horizontalAlignment: Text.AlignHCenter
        color: 'white'
        text: "0"
    }

    Text {
        x: 260
        y: 460
        font.pointSize: 30
        font.weight: Font.Light
        color: 'white'
        text: "km/h"
    }


//    Text {
//        x: 260
//        y: 260
//        font.pointSize: 140
//        font.weight: Font.Light
//        //anchors.horizontalCenter: parent.horizontalCenter
//        //horizontalAlignment: Text.AlignHCenter
//        color: 'white'
//        text: "0"
//    }

//    Text {
//        x: 260
//        y: 460
//        font.pointSize: 30
//        font.weight: Font.Light
//        color: 'white'
//        text: "km/h"
//    }
}
