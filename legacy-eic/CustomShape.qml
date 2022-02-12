import QtQuick 2.0
import QtQuick.Shapes 1.15

Shape {
    id: shape
    transform: Translate { x: shape.width / 2; y: shape.height / 2 - 6 * shape.height / 100}
    width: parent.width
    height: parent.height
    ShapePath {
        scale: Qt.size(shape.width / 200, shape.height / 100)
        strokeWidth: 1.5
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
}
