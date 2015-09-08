import QtQuick 2.2
import QmlVlc 0.1

Rectangle {
    color: "transparent"
    anchors.fill: parent
    focus: true

    property string mediaDir
    property string mediaSource
    property int detailsHeight

    property bool inRange: mediaSlides.currentIndex === index

    onInRangeChanged: {
        if(!inRange && mediaPlayer.playbackState == MediaPlayer.PlayingState) mediaPlayer.pause()
    }

    VlcPlayer {
        id: mediaPlayer
        mrl: mediaDir + "/" + mediaSource
        volume: 100

        onStateChanged: {
            if(state == VlcPlayer.Error) console.log("Video " + mediaAlias + " error.")
        }
    }

    VlcVideoSurface {
        id: video
        width: parent.width
        height: parent.height - detailsHeight
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

            onPlay: {
                if(inRange) mediaPlayer.play()
            }

            onPause: mediaPlayer.pause()

            onStop: mediaPlayer.stop()

            onSeek: {
                if(mediaPlayer.state !== VlcPlayer.Stopped) {
                    mediaPlayer.position = seekTo
                }
            }
        }
    }

    Flow {
        id: mediaDetailsRect
        width: parent.width
        height: detailsHeight - anchors.topMargin
        spacing: 10

        anchors {
            top: video.bottom
            topMargin: 5
        }


        Row {
            width: childrenRect.width
            height: 30
            spacing: 10

            Text {
                text: "Name"
                color: "white"
                font.pixelSize: 15
                opacity: .6
            }

            Rectangle {
                width: 200
                height: parent.height * .8
                color: "white"
                radius: 5

                TextInput {
                    id: mediaName
                    text: mediaAlias
                    color: "#111111"
                    font.pixelSize: 14
                    selectByMouse: true
                    selectionColor: "#333333"
//                    focus: true
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter

                    clip: true

                    anchors.fill: parent

                    anchors {
                        left: parent.left
                        leftMargin: 5
                        right: parent.right
                        rightMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Row {
            width: childrenRect.width
            height: 30
            spacing: 5

            Text {
                text: "Resolution:"
                color: "white"
                font.pixelSize: 15
                opacity: .6
            }

            Text {
                text: videoResolution
                color: "white"
                font.pixelSize: 15
            }
        }

        Row {
            width: childrenRect.width
            height: 30
            spacing: 5

            Text {
                text: "Codec:"
                color: "white"
                font.pixelSize: 15
                opacity: .6
            }

            Text {
                text: videoCodec
                color: "white"
                font.pixelSize: 15
            }
        }

        Row {
            width: childrenRect.width
            height: 30
            spacing: 5

            Text {
                text: "Frame rate:"
                color: "white"
                font.pixelSize: 15
                opacity: .6
            }

            Text {
                text: videoFrameRate
                color: "white"
                font.pixelSize: 15
            }
        }

        Row {
            width: childrenRect.width
            height: 30
            spacing: 5

            Text {
                text: "Size:"
                color: "white"
                font.pixelSize: 15
                opacity: .6
            }

            Text {
                text: mediaSize + "MB"
                color: "white"
                font.pixelSize: 15
            }
        }
    }
}
