import QtQuick 2.2

Item {

    property bool aspectFill: true
    property bool loaded: false
    property string mediaSource
    property string mediaAlias
    signal touched()

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

        MouseArea {
            anchors.fill: parent

            onClicked: {
                touched()
            }
        }
    }
}
