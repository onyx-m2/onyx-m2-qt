import QtQuick 2.15

pragma Singleton

Item {
    property color white: '#b0b0b0'
    property color grey: '#2a2a2a'
    readonly property color blue: '#3e6ae1'
    readonly property color red: '#d3122d'
    readonly property color black: '#000000'
    readonly property color green: '#21ba45'
    readonly property color yellow: '#fbbe08'
    readonly property color orange: '#f2711c'

    property bool previousIsSunUp: false

    Canbus {
        interval: 1000
        onUpdate: {
            const isSunUp = sig('UI_isSunUp')
            if (isSunUp != previousIsSunUp) {
                if (isSunUp) {
                    white = '#ffffff'
                    grey = '#969696'
                } else {
                    white = '#b0b0b0'
                    grey = '#1a1a1a'
                }
                previousIsSunUp = isSunUp
            }
        }
    }
}
