import QtQuick 2.5
import QmlVlc 0.1

Rectangle {
    color: "transparent"
    anchors.fill: parent
    focus: true

    property string mediaDir
    property string mediaSource

    property bool inRange: false

    onInRangeChanged: {
        if(!inRange) mediaPlayer.pause()
        else mediaPlayer.mrl = mediaDir + "/" + mediaSource
    }

    VlcPlayer {
        id: mediaPlayer
        volume: 100

        onStateChanged: {
            if(state == VlcPlayer.Error) console.log("Video " + mediaAlias + " error.")
        }
    }

    VlcVideoSurface {
        id: video
        anchors.fill: parent
        fillMode: Qt.KeepAspectRatio
        source: mediaPlayer

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
            durationSec: Math.ceil(videoDuration / 1000)

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
