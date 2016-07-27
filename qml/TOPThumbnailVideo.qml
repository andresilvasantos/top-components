import QtQuick 2.5
import QmlVlc 0.1

Item {
    id: mainRect

    property bool loaded: false
    property string mediaSource
    property string mediaAlias

    signal clicked()
    signal doubleClicked()

    Rectangle {
        anchors.fill: parent
        border.width: 1
        border.color: "#cccccc"
        color: "#aaaaaa"
    }

    VlcVideoSurface {
        id: video
        anchors.fill: parent
        fillMode: Qt.KeepAspectRatioByExpanding
        source: mediaPlayer

        VlcPlayer {
            id: mediaPlayer

            onStateChanged: {
                if(state == VlcPlayer.Ended || state == VlcPlayer.Error) {
                    stop()
                }
            }
        }
    }

    Image {
        id: icon
        width: 30
        height: width
        fillMode: Image.PreserveAspectFit
        source: "qrc:/components/images/video"
        visible: !mouseArea.hovered
        anchors.centerIn: parent
    }

    TOPLoadingBubbles {
        anchors.fill: parent
        visible: mouseArea.hovered && mediaPlayer.state != VlcPlayer.Ended && mediaPlayer.state != VlcPlayer.Playing && mediaPlayer.state != VlcPlayer.Stopped
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        property bool hovered: false

        onHoveredChanged: {
            if(hovered) {
                if(mediaPlayer.state !== VlcPlayer.Error) {
                    mediaPlayer.mrl = mediaSource
                    mediaPlayer.play()
                }
            }
            else {
                if(mediaPlayer.state !== VlcPlayer.Error) {
                    mediaPlayer.stop()
                }
            }
        }

        onClicked: {
            mainRect.clicked()
        }

        onDoubleClicked: {
            mainRect.doubleClicked()
        }

        onEntered: {
            hovered = true
        }

        onExited: {
            hovered = false
        }
    }

    Component.onCompleted: {
        loaded = true
    }
}
