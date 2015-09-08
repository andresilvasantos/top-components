import QtQuick 2.2
import QmlVlc 0.1

VlcVideoSurface {
    id: video
    anchors.fill: parent
    fillMode: Qt.KeepAspectRatioByExpanding
    source: mediaPlayer

    property bool loaded: false
    property string mediaSource
    property string mediaAlias
    signal touched()

    VlcPlayer {
        id: mediaPlayer

        onStateChanged: {
            if(state == VlcPlayer.Ended || state == VlcPlayer.Error) {
                stop()
            }
        }
    }

    Image {
        id: icon
        width: 30
        height: width
        fillMode: Image.PreserveAspectFit
        source: "qrc:/components/images/video"

        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            touched()
        }

        onExited: {
            if(mediaPlayer.state !== VlcPlayer.Error) {
                mediaPlayer.stop()
                icon.visible = true
            }
        }

        onEntered: {
            if(mediaPlayer.state !== VlcPlayer.Error) {
                mediaPlayer.mrl = mediaSource
                mediaPlayer.play()
                icon.visible = false
            }
        }
    }

    Component.onCompleted: {
        loaded = true;
    }
}
