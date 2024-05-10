import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int currentOverlay: 0
    property var overlays: [
        'TripOverlay.qml',
        'PowerOverlay.qml',
        'TemperatureOverlay.qml',
        'TirePressureOverlay.qml',
    ]
    property int scrollWheelIgnoreCycles: 0

    property int gear: 7 // SNA
    property int autopilotState: 0
    property int handsOnState: 0

    property int breakLightStatus: 0
    property int leftTurnLightStatus: 0
    property int rightTurnLightStatus: 0

    readonly property int indicatorWidth: vw(10)
    readonly property int indicatorHeight: vh(1.2)
    readonly property int indicatorRadius: 0

    anchors.centerIn: parent

    // The indicator bar is really thin and displays at the top of the screen
    // IndicatorBar {
    //     id: indicatorBar
    //     width: vw(100)
    //     height: lineWidth * 2
    // }

    // The primary section holds the speed and battery gauges, as well as the PRND
    // indicator, and is the larger cluster
    // PrimarySection {
    //     id: primarySection
    //     anchors {
    //         top: indicatorBar.bottom
    //         topMargin: rowSpacing
    //         bottom: powerSection.top
    //         bottomMargin: rowSpacing
    //     }
    //     width: vw(100)
    //     //height: vh(25)
    // }

    Item {
        id: gearIndicator
        anchors {
            top: parent.top
            left: parent.left
        }

        RowLayout {
            Text {
                text: 'P'
                color: gear === 1 ? Colors.white : Colors.grey
                font.weight: gear === 1 ? Font.Bold : Font.Normal
            }
            Text {
                text: 'R'
                color: gear === 2 ? Colors.white : Colors.grey
                font.weight: gear === 2 ? Font.Bold : Font.Normal
            }
            Text {
                text: 'N'
                color: gear === 3 ? Colors.white : Colors.grey
                font.weight: gear === 3 ? Font.Bold : Font.Normal
            }
            Text {
                text: 'D'
                color: gear === 4 ? Colors.white : Colors.grey
                font.weight: gear === 4 ? Font.Bold : Font.Normal
            }
        }
    }

    BatteryIndicator {
        id: batteryIndicator
        anchors {
            top: parent.top
            right: parent.right
        }
        width: vw(7)
        height: vh(5)
    }

    // The power section shows power/regen for all motors, and is second in size to
    // the primary cluster
    PowerSection {
        id: powerSection
        anchors {
            top: batteryIndicator.bottom
            topMargin: rowSpacing / 2
            //bottomMargin: batteryIndicator.height + rowSpacing
        }
        width: vw(100)
    }

    RowLayout {
        anchors {
            top: powerSection.bottom
            topMargin: rowSpacing
            //bottom: childrenRect.bottom
        }
        width: vw(100)
        spacing: 100
//Layout.fillHeight: true

        SpeedIndicator {
            Layout.alignment: Qt.AlignTop + Qt.AlignHCenter
            //Loyout.preferredWidth: vw(15)
            // anchors {
            //     left: parent.left
            //     //leftMargin: parent.width / 10
            //     //right: parent.horizontalCenter
            //     //horizontalCenter: parent.horizontalCenter
            //     top: powerSection.bottom
            //     topMargin: rowSpacing
            //     //verticalCenter: parent.verticalCenter
            // }
            width: vw(30)
            height: vh(38)
        }

        Loader {
            id: overlay
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop + Qt.AlignHCenter
            Layout.fillHeight: true
            //Layout.alignment: Qt.AlignHCenter
            // anchors {
            //     top: powerSection.bottom
            //     topMargin: rowSpacing
            //     bottom: parent.bottom
            //     horizontalCenter: parent.horizontalCenter
            //     // left: SpeedIndicator.right
            //     // right: speedLimitIndicator.left
            // }
            //width: vw(60)
            source: overlays[0]
        }

        // Loader {
        //     id: overlay
        //     Layout.fillWidth: true
        //     // anchors {
        //     //     top: powerSection.bottom
        //     //     topMargin: rowSpacing
        //     //     bottom: parent.bottom
        //     //     horizontalCenter: parent.horizontalCenter
        //     //     // left: SpeedIndicator.right
        //     //     // right: speedLimitIndicator.left
        //     // }
        //     //width: vw(50)
        //     source: overlays[0]
        // }
        // Item {
        //     width: vw(20)
        //     height: vh(28)
        //     Layout.alignment: Qt.AlignTop + Qt.AlignRight
        //     //Layout.topMargin: vh(2)
        //     SpeedLimitIndicator {
        //         id: speedLimitIndicator
        //         anchors {
        //             top: parent.top
        //             right: parent.right
        //             //rightMargin: vw(1)
        //         }
        //         width: vw(11)
        //         height: vh(22)
        //         // anchors {
        //         //     right: parent.right
        //         //     //leftMargin: rowSpacing
        //         //     //horizontalCenter: parent.horizontalCenter
        //         //     //verticalCenter: parent.verticalCenter
        //         //     top: powerSection.bottom
        //         //     topMargin: rowSpacing
        //         // }
        //     }
        // }
    }

    Rectangle {
        id: leftTurnIndicator
        anchors {
            left: parent.left
            bottom: parent.bottom
            bottomMargin: vh(2)
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: indicatorHeight
        color: Colors.green
        opacity: (leftTurnLightStatus === 1) ? 1.0 : 0.0
    }

    Rectangle {
        id: stopIndicator
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: vh(2)
        }
        width: indicatorWidth * 4
        radius: indicatorRadius
        height: indicatorHeight
        color: Colors.red
        opacity: (breakLightStatus === 1 /* ON */) ? 1.0 : 0.0
    }

    Rectangle {
        id: rightTurnIndicator
        anchors {
            right: parent.right
            bottom: parent.bottom
            bottomMargin: vh(2)
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: indicatorHeight
        color: Colors.green
        opacity: (rightTurnLightStatus === 1) ? 1.0 : 0.0
    }

    // TripSection {
    //     id: secondarySection
    //     anchors {
    //         top: indicatorBar.bottom
    //         topMargin: rowSpacing
    //         bottom: powerSection.top
    //         bottomMargin: rowSpacing
    //     }
    //     width: vw(100)
    //     // height: vh(15)
    // }

    // BatteryIndicator {
    //     id: batteryIndicator
    //     anchors {
    //         bottom: parent.bottom
    //         right: parent.right
    //     }
    //     width: vw(9)
    //     height: vh(5)
    // }

    // Text {
    //     anchors.bottom: parent.bottom
    //     color: 'blue'
    //     text: 'brake:' + breakLightStatus + ' regen:' + regenLight + ' left:' + leftTurnLightStatus + ' right:' + rightTurnLightStatus
    // }

    // need a really short interval here because we're polling
    // for scroll ticks and we'll just not see them if the interval
    // is too long; we'll still debounce to avoid cycling more than
    // one overlay per "flip" of the wheel
    Canbus {
        interval: 10
        onUpdate: {
            breakLightStatus = sig('VCRIGHT_brakeLightStatus')
            leftTurnLightStatus = sig('VCLEFT_turnSignalStatus')
            rightTurnLightStatus = sig('VCRIGHT_turnSignalStatus')
            if (breakLightStatus === 1 /* ON */) {
                leftTurnLightStatus = !leftTurnLightStatus
                rightTurnLightStatus = !rightTurnLightStatus
            }

            if (scrollWheelIgnoreCycles == 0) {
                const autopilotState = sig('DAS_autopilotState')
                if (autopilotState !== 3 /* ACTIVE_NOMINAL */) {
                    const ticks = sig('VCLEFT_swcRightScrollTicks')
                    if (ticks > 0) {
                        scrollDisplayUp()
                        scrollWheelIgnoreCycles = 50
                    }
                    else
                    if (ticks < 0) {
                        scrollDisplayDown()
                        scrollWheelIgnoreCycles = 50
                    }
                }
            }
            else {
                scrollWheelIgnoreCycles--
            }

            gear = sig('DI_gear')
            autopilotState = sig('DAS_autopilotState')
        }
    }

    function scrollDisplayUp() {
        currentOverlay = currentOverlay < overlays.length - 1 ? currentOverlay + 1 : 0
        overlay.source = overlays[currentOverlay]
    }

    function scrollDisplayDown() {
        currentOverlay = currentOverlay > 0 ? currentOverlay - 1 : overlays.length - 1
        overlay.source = overlays[currentOverlay]
    }

    focus: true
    Keys.onPressed: (e) => {
        switch (e.key) {
            case Qt.Key_PageUp:
                scrollDisplayUp()
                break

            case Qt.Key_PageDown:
                scrollDisplayDown()
                break

            default: return
        }
        e.accepted = true
    }


}
