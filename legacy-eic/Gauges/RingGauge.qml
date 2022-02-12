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

    function angle() {
        const totalAngle = Math.asin(height / radius)
        const clampedValue = Math.max(0, Math.min(100, value))
        return ((clampedValue - 50) / 100) * totalAngle
    }

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
                    var pos = Math.cos(-angle()) * radius
                    if (gauge.direction === PathArc.Clockwise) {
                        pos = -pos
                    }
                    return pos + offset
                }
                y: {
                    Math.sin(-angle()) * radius + height / 2
                }
                direction: gauge.direction
            }
        }
    }
}
