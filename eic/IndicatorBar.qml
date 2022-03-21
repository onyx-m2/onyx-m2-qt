import QtQuick 2.0
import QtQuick.Layouts 1.15
import Components 1.0

Item {
    property int breakLightStatus: 0
    property int leftTurnLightStatus: 0
    property int rightTurnLightStatus: 0

    property bool lanePositionKnown: false
    property int deviationFromLaneCenter: 0

    property int turn: 0

    // look and feel
    readonly property int indicatorWidth: vw(9)
    readonly property int indicatorRadius: 0

    Rectangle {
        id: leftTurnIndicator
        anchors {
            left: parent.left
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: parent.height
        color: Colors.green
        opacity: (leftTurnLightStatus === 1) ? 1.0 : 0.0
    }

    Rectangle {
        id: leftStopIndicator
        anchors {
            left: leftTurnIndicator.right
            leftMargin: lineWidth * 2
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: parent.height
        color: Colors.red
        opacity: (breakLightStatus === 1 /* ON */) ? 1.0 : 0.0
    }

    Rectangle {
        id: laneIndicator
        anchors {
            left: leftStopIndicator.right
            leftMargin: lineWidth * 2
            right: rightStopIndicator.left
            rightMargin: lineWidth * 2
        }
        height: parent.height / 2
        radius: indicatorRadius
        color: Colors.grey
    }

    Rectangle {
        anchors {
            centerIn: parent
            verticalCenterOffset: laneIndicator.height
            horizontalCenterOffset: {
                const maxOffset = (laneIndicator.width - width) / 2
                const interval = maxOffset / 100
                return Math.max(-maxOffset, Math.min(deviationFromLaneCenter * interval, maxOffset))
            }
        }
        width: vw(4)
        height: parent.height / 2
        radius: indicatorRadius
        opacity: lanePositionKnown ? 1.0 : 0.0
        color: Math.abs(deviationFromLaneCenter) < 100 ? Colors.white : Colors.yellow

        Behavior on anchors.horizontalCenterOffset {
            NumberAnimation  {
                easing.type: Easing.InOutQuad
                duration: 300
            }
        }
    }

    Rectangle {
        id: rightStopIndicator
        anchors {
            right: rightTurnIndicator.left
            rightMargin: lineWidth * 2
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: parent.height
        color: Colors.red
        opacity: (breakLightStatus === 1 /* ON */) ? 1.0 : 0.0
    }

    Rectangle {
        id: rightTurnIndicator
        anchors {
            right: parent.right
        }
        width: indicatorWidth
        radius: indicatorRadius
        height: parent.height
        color: Colors.green
        opacity: (rightTurnLightStatus === 1) ? 1.0 : 0.0
    }

    Canbus {
        onUpdate: {
            breakLightStatus = sig('VCLEFT_brakeLightStatus')
            leftTurnLightStatus = sig('VCLEFT_turnSignalStatus')
            rightTurnLightStatus = sig('VCRIGHT_turnSignalStatus')
            //turn = canbus.signal('SCCM_turnIndicatorStalkStatus')
            //turn = canbus.signal('DAS_turnIndicatorRequest')
            //VCFRONT_turnSignalLeftStatus

            // calculate lane keeping values, if autopilot is able to make sense of
            // its surroundings
            const carWidth = 1.85 // m
            const validLine = 2 // FUSED
            const leftLineUsage = sig('DAS_leftLineUsage')
            const rightLineUsage = sig('DAS_rightLineUsage')
            const laneWidth = sig('DAS_virtualLaneWidth') // m
            const distanceFromLaneCenter = sig('DAS_virtualLaneC0') // cm

            if ((leftLineUsage !== validLine && rightLineUsage !== validLine) || laneWidth === 0) {
                lanePositionKnown = false
            } else {
                lanePositionKnown = true
                // 0% : exactly in the middle
                // 100% : left or right side of the car is touching the lane markers
                const movementSpaceInLane = (laneWidth - carWidth) / 2
                deviationFromLaneCenter = -distanceFromLaneCenter / movementSpaceInLane
                //const lanePositionColor = Math.abs(deviationFromLaneCenter) < 100 ? theme.color.highlight : Colors.red
            }
        }
    }
}