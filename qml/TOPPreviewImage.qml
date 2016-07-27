import QtQuick 2.5

Rectangle {
    color: "transparent"
    anchors.fill: parent

    property string mediaDir
    property string mediaSource
    property var imageComponent: image

    Image {
        id: imageTransparent
        width: image.paintedWidth - 1
        height: image.paintedHeight - 1
        fillMode: Image.Tile
        sourceSize.width: 40
        sourceSize.height: 40
        asynchronous: true
        source: "qrc:/components/images/transparency"
        cache: true
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignTop

        anchors.centerIn: image
    }

    Image {
        id: image
        anchors.fill: parent
        source: mediaDir + "/" + mediaSource
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: false
    }
}
