import QtQuick 2.5

Item {
    id: mainRect

    property bool aspectFill: true
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
        visible: image.status != Image.Ready
    }

    Image {
        id: imageTransparent
        fillMode: Image.Tile
        sourceSize.width: 40
        sourceSize.height: 40
        asynchronous: true
        source: "qrc:/components/images/transparency"
        cache: true
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignTop
        visible: image.status == Image.Ready

        anchors.fill: parent
    }

    Image {
        id: image
        fillMode: aspectFill ? Image.PreserveAspectCrop : Image.PreserveAspectFit
        sourceSize.width: 300
        sourceSize.height: 300
        asynchronous: true
        source: mediaSource
        cache: true

        anchors.fill: parent

        onProgressChanged: {
            if(image.progress == 1) loaded = true
        }

        Timer {
            interval: 2000
            repeat: true
            running: image.status == Image.Error
            onTriggered: {
                image.source = ""
                image.source = mediaSource
            }
        }
    }

    TOPLoadingBubbles {
        anchors.fill: parent
        visible: image.status != Image.Ready
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            mainRect.clicked()
        }

        onDoubleClicked: {
            mainRect.doubleClicked()
        }
    }
}
