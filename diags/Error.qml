import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
Item {
    id: app
    property var errors: ['No errors detected!']
    ColumnLayout {
        Text {
             color: 'white'
             text: "[Onyx M2 Qt Error]"
         }
         Text {
             Layout.maximumWidth: app.width || Screen.width
             color: 'white'
             wrapMode: Text.WordWrap
             text: errors.join('\n')
         }
    }
}
