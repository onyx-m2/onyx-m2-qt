import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.11
import Theme 1.0
import Gauges 1.0

Item {
    id: app

    readonly property int contourLineWidth: vh(0.8)
    readonly property int separatorLineWidth: 0.002 * height
    readonly property int gaugeBarWidth: vw(2)

    function vh(pct) { return pct * height / 100 }
    function vw(pct) { return pct * width / 100 }

    property string odometer: '0'
    property string capacity: '0'
    property string speed: '0'
    property string soc: '90'
    property string range: '400'
    property int power: 450
    property int limit: 100
    property bool limitVisible: true

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: leftCluster
            Layout.preferredWidth: vw(30)
            Layout.preferredHeight: vh(56)

            PrimaryIndicator {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: vh(8)
                }
                value: speed;
                label: 'km/h'
            }

            SecondaryIndicator {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: vh(4)
                }
                opacity: limitVisible
                label: 'max'
                value: limit
                state: 'labelLeft'
            }

            Shape {
                id: leftContour
                readonly property int l: parent.width * 0.2
                readonly property int r: parent.width * 0.92
                readonly property int t: 0
                readonly property int b: parent.height
                readonly property int radius: parent.width * 2

                ShapePath {
                    strokeWidth: contourLineWidth
                    strokeColor: Theme.primary
                    fillColor: 'transparent'
                    PathMove { x: leftContour.r; y: leftContour.t }
                    PathLine { x: leftContour.l; y: leftContour.t }
                    PathArc {
                        direction: PathArc.Counterclockwise;
                        radiusX: leftContour.radius
                        radiusY: leftContour.radius
                        x: leftContour.l;
                        y: leftContour.b
                    }
                    PathLine { x: leftContour.r; y: leftContour.b }
                }
            }

            ArcGauge {
                radius: parent.width * 2.1
                value: speed
            }
        }

        Item {
            //color: 'red'
            id: centerCluster
            Layout.preferredWidth: vw(40)
            Layout.preferredHeight: vh(80)

            PrimaryIndicator {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: vh(4)
                }
                value: power
                label: 'kw'
                state: 'hero'
            }

            Shape {
                id: centerContour
                readonly property int l: parent.width * 0.22
                readonly property int r: parent.width * 0.78
                readonly property int radius: parent.height * 0.5
                readonly property int b: parent.height * 0.93
                ShapePath {
                    strokeWidth: contourLineWidth
                    strokeColor: Theme.primary
                    fillColor: 'transparent'
                    startX: centerContour.l
                    startY: centerContour.b
                    PathArc { useLargeArc: true; radiusX: centerContour.radius; radiusY: centerContour.radius; x: centerContour.r; y: centerContour.b}
                    PathLine { x: centerContour.l; y: centerContour.b }
                }
            }

            Shape {
                id: ringBack
                readonly property int l: parent.width * 0.075
                readonly property int r: parent.width * 0.925
                readonly property int radius: parent.height * 0.55
                readonly property int b: parent.height * 0.89
                ShapePath {
                    strokeWidth: gaugeBarWidth
                    strokeColor: Theme.primary
                    fillColor: 'transparent'
                    PathMove { x: ringBack.l; y: ringBack.b }
                    PathArc { radiusX: ringBack.radius; radiusY: ringBack.radius; x: vw(20); y: vh(-4)}
                }
                ShapePath {
                    strokeWidth: gaugeBarWidth
                    strokeColor: Theme.primary
                    fillColor: 'transparent'
                    PathMove { x: ringBack.l; y: ringBack.b }
                    PathArc { useLargeArc: true; radiusX: ringBack.radius; radiusY: ringBack.radius; x: ringBack.r; y: ringBack.b}
                }
            }

            Banner {
                opacity: speed == 0
                caption: 'BREAKING'
                wrapper: Colors.red
            }

            SecondaryIndicator {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: vh(10)
                }
                value: '137'
                label: 'wh/km'
            }
        }

        Item  {
            id: rightCluster
            Layout.preferredWidth: vw(30)
            Layout.preferredHeight: vh(56)

            PrimaryIndicator {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: vh(8)
                }
                value: soc;
                label: 'percent'
            }

            SecondaryIndicator {
                anchors {
                    left: parent.left
                    leftMargin: vw(7)
                    bottom: parent.bottom
                    bottomMargin: vh(4)
                }
                value: range
                label: 'km'
            }

            Shape {
                id: rightContour
                readonly property int l: parent.width * 0.08
                readonly property int r: parent.width * 0.80
                readonly property int t: 0
                readonly property int b: parent.height
                readonly property int radius: parent.width * 2

                ShapePath {
                    strokeWidth: contourLineWidth
                    strokeColor: Theme.primary
                    fillColor: 'transparent'
                    PathMove { x: rightContour.l; y: rightContour.t }
                    PathLine { x: rightContour.r; y: rightContour.t }
                    //PathArc { radiusX: leftCluster.width * 0.65; radiusY: leftCluster.height; x: rightContour.r; y: rightContour.b }
                    PathArc { radiusX: rightContour.radius; radiusY: rightContour.radius; x: rightContour.r; y: rightContour.b }
                    PathLine { x: rightContour.l; y: rightContour.b }
                }
            }

            ArcGauge {
                anchors {
                    right: parent.right
                    rightMargin: vw(6)
                }
                direction: PathArc.Counterclockwise
                radius: parent.width * 2.1
                value: soc
            }
         }
     }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            speed = canbus.signal('DI_uiSpeed').toLocaleString(Qt.locale('us_EN'), 'f', 0)
            soc = canbus.signal('UI_usableSOC').toLocaleString(Qt.locale('us_EN'), 'f', 0)
            range = canbus.signal('UI_expectedRange').toLocaleString(Qt.locale('us_EN'), 'f', 0)
            power = canbus.signal('DI_elecPower')
            var fusedLimit = canbus.signal('DAS_fusedSpeedLimit')
            if (fusedLimit !== 0 && fusedLimit !== 31 /* NONE */) {
                limit = fusedLimit
                limitVisible = true
            } else {
                limitVisible = false
            }

            odometer = canbus.signal('UI_odometer').toLocaleString(Qt.locale('us_EN'), 'f', 2)
            var nominalFullPack = canbus.signal('BMS_nominalFullPack')
            var initialFullPack = canbus.signal('BMS_initialFullPack')
            if (nominalFullPack !== 0 && initialFullPack !== 0) {
                const value = nominalFullPack * 100 / initialFullPack
                capacity = value.toLocaleString(Qt.locale('us_EN'), 'f', 0) + '%'
            }
        }
    }
}
