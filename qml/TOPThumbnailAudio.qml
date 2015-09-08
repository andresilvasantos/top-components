import QtQuick 2.2
//import QtMultimedia 5.0
import QmlVlc 0.1

Rectangle {
    color: "#444444"

    property bool loaded: false
    property string mediaSource
    property string mediaAlias
    signal touched()

    VlcPlayer {
        id: mediaPlayer
        mrl: mediaSource
        volume: 100

        onStateChanged: {
            if(state == VlcPlayer.Error) console.log("Audio " + mediaAlias + " error.")
        }
    }

    /*Audio {
        id: audio
        autoLoad: false
        source: mediaSource

        onErrorStringChanged: {
            console.log("Audio " + mediaAlias + " error: " + errorString)
        }
    }*/

    Image {
        id: icon
        width: 30
        height: width
        fillMode: Image.PreserveAspectFit
        source: "qrc:/components/images/sound"

        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            touched()
        }

        onExited: {
            if(mediaPlayer.error === mediaPlayer.NoError) {
                mediaPlayer.stop()
                icon.visible = true
            }
        }

        onEntered: {
            if(mediaPlayer.error === mediaPlayer.NoError) {
                mediaPlayer.play()
                icon.visible = false
            }
        }
    }

    Component.onCompleted: {
        loaded = true
    }
}
