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

    function debounce(fn, delay) {
      const now = Date.now()
      if (now - lastTriggered > delay) {
        lastTriggered = now
        return fn()
      }
      return 0
    }

    onTriggered: {
      update()
    }
}