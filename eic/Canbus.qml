import QtQuick 2.15

Timer {
    signal update()

    interval: 100
    running: true
    repeat: true

    function sig(mnemonic) {
      return canbus.signal(mnemonic)
    }

    onTriggered: update()
}