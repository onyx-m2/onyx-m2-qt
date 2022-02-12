import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
Item {
    id: app
    property var errors: ['No errors detected!']
    readonly property int titlefontSize: 0.06 * (height || Screen.height)
    readonly property int bodyfontSize: 0.04 * (height || Screen.height)
    ColumnLayout {
        Text {
             color: 'white'
             font.pointSize: titlefontSize
             text: "[Onyx Pi] Error"
         }
         Text {
             Layout.maximumWidth: app.width || Screen.width
             color: 'white'
             font.pointSize: bodyfontSize
             wrapMode: Text.WordWrap
             text: errors.join('\n')
         }
    }
}
