import QtQuick 2.5
//import QtMultimedia 5.0
import QmlVlc 0.1

Rectangle {
    anchors.fill: parent
    color: "transparent"

    property string mediaDir
    property string mediaSource
    property bool inRange: false

    onInRangeChanged: {
        if(!inRange) mediaPlayer.pause()
        else mediaPlayer.mrl = mediaDir + "/" + mediaSource
    }

    Rectangle {
        id: audioHolder
        anchors.fill: parent
        color: "#444444"

        VlcPlayer {
            id: mediaPlayer
            volume: 100

            onStateChanged: {
                if(state == VlcPlayer.Error) console.log("Audio " + mediaAlias + " error.")
            }
        }

        TOPMediaControl {
            height: 30

            anchors {
                left: parent.left
                leftMargin: 20
                right: parent.right
                rightMargin: 20
                bottom: parent.bottom
                bottomMargin: 20
            }

            playing: mediaPlayer.state == VlcPlayer.Playing
            currentSeekSec: Math.ceil(mediaPlayer.position * durationSec)
            durationSec: Math.ceil(audioDuration / 1000)

            onPlay: mediaPlayer.play()

            onPause: mediaPlayer.pause()

            onStop: mediaPlayer.stop()

            onSeek: {
                if(mediaPlayer.state !== VlcPlayer.Stopped) {
                    mediaPlayer.position = seekTo
                }
            }
        }
    }
}
