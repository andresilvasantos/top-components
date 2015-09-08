import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import "qrc:/components/qml/"

RowLayout {
    focus: true
    spacing: 12

    property bool playing: false
    property int currentSeekSec: 0
    property int durationSec: 0
    property bool seeking: false
    signal play()
    signal pause()
    signal stop()
    signal seek(real seekTo)

    onDurationSecChanged: {
        if(durationSec < 0) durationSeekText.text = numberToTimeFormat(0)
        else durationSeekText.text = numberToTimeFormat(durationSec)
    }

    onCurrentSeekSecChanged: {
        if(seeking) return

        if(durationSec > 0) seekSlider.value = currentSeekSec / durationSec
        positionSeekText.text = numberToTimeFormat(currentSeekSec)
    }

    function numberToTimeFormat(number) {
        var sec = Math.floor(number)
        var min = Math.floor(sec / 60)

        sec = sec - min * 60

        var secStr = sec.toString()
        var minStr = min.toString()

        while(secStr.length < 2)
        {
            secStr = "0" + secStr
        }
        while(minStr.length < 2)
        {
            minStr = "0" + minStr
        }

        return minStr + ":" + secStr
    }

    TOPButton {
        id: buttonPlay
        width: 80
        height: parent.height
        color: "#212121"
        hoverColor: "#002E4C"
        selectedColor: "#0099FF"
        radius: 5

        Text {
            text: playing ? "PAUSE" : "PLAY"
            color: "white"

            anchors.centerIn: parent
        }

        onClicked: {
            if(playing) pause()
            else play()
        }
    }

    TOPButton {
        id: buttonStop
        width: 80
        height: parent.height
        color: "#212121"
        hoverColor: "#002E4C"
        selectedColor: "#0099FF"
        radius: 5

        Text {
            text: "STOP"
            color: "white"

            anchors.centerIn: parent
        }

        onClicked: {
            stop()
        }
    }

    Row {
        Text {
            id: positionSeekText
            font.pixelSize: 14
            text: "00:00"
            color: "white"
        }

        Text {
            id: separatorSeekText
            font.pixelSize: 14
            text: " / "
            color: "white"
        }

        Text {
            id: durationSeekText
            font.pixelSize: 14
            text: "00:00"
            color: "white"
        }
    }

    Rectangle {
        Layout.fillWidth: true

        TOPSlider {
            id: seekSlider
            focus: true
            value: 0

            anchors {
                left: parent.left
                leftMargin: 10
                right: parent.right
                rightMargin: 10
            }

            onSliderMoved: {
                seeking = true
                positionSeekText.text = numberToTimeFormat(value * durationSec)
            }

            onSliderReleased: {
                seeking = false
                seek(value)
            }
        }
    }
}
