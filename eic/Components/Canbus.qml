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
        return fn()
      }
      return 0 
    } 

    onTriggered: { 
      lastTriggered = Date.now()
      update()
    }
}