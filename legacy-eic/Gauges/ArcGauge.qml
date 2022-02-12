import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.11
import Theme 1.0

Item {
    id: gauge
    width: vw(2)
    height: parent.height

    property int direction: PathArc.Clockwise
    property real radius: 0
    property int value: 0
    property int maxValue: 90

    function angle(value) {
        const totalAngle = Math.asin(height / radius)
        const clampedValue = Math.max(0, Math.min(maxValue, value))
        return ((clampedValue - 50) / 100) * totalAngle
    }

    // Background of the gauge, sweeps the entire curve in the primary color
    Shape {
        ShapePath {
            strokeWidth: width
            strokeColor: Theme.primary
            fillColor: 'transparent'
            startX: width * 2
            startY: parent.height
            PathArc {
                radiusX: radius
                radiusY: radius
                x: width * 2
                y: 0
                direction: gauge.direction
            }
        }
    }

    // Disabled part of the gauge, sweeps from the top to maxValue in a grey color
    Shape {
        ShapePath {
            strokeWidth: width / 1.4
            strokeColor: Colors.grey
            fillColor: 'transparent'
            startX: width * 2
            startY: 0
            PathArc {
                radiusX: radius
                radiusY: radius
                x: {
                    var offset = -(Math.cos(Math.asin(height / radius / 2)) * radius)
                    if (gauge.direction === PathArc.Clockwise) {
                        offset = -offset
                    }
                    offset += width * 2
                    var pos = Math.cos(-angle(maxValue)) * radius
                    if (gauge.direction === PathArc.Clockwise) {
                        pos = -pos
                    }
                    return pos + offset
                }
                y: {
                    Math.sin(-angle(maxValue)) * radius + height / 2
                }
                direction: gauge.direction
            }
        }
    }

    // Indicator, sweeps from the bottom up to value in the gauge color
    Shape {
        ShapePath {
            strokeWidth: width / 1.4
            strokeColor: Colors.green//Theme.highlight
            fillColor: 'transparent'
            startX: width * 2
            startY: parent.height
            PathArc {
                radiusX: radius
                radiusY: radius
                x: {
                    var offset = -(Math.cos(Math.asin(height / radius / 2)) * radius)
                    if (gauge.direction === PathArc.Clockwise) {
                        offset = -offset
                    }
                    offset += width * 2
                    var pos = Math.cos(-angle(value)) * radius
                    if (gauge.direction === PathArc.Clockwise) {
                        pos = -pos
                    }
                    return pos + offset
                }
                y: {
                    Math.sin(-angle(value)) * radius + height / 2
                }
                direction: gauge.direction
            }
        }
    }
}
