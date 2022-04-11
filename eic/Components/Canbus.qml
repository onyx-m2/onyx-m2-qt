import QtQuick 2.15

Timer {
    property var lastTriggered: 0
    signal update()

    interval: 100
    running: true
    repeat: true
    triggeredOnStart: true

    function sig(mnemonic) {
      return canbus.signal(mnemonic)
    }

    onTriggered: {
      update()
    }
}