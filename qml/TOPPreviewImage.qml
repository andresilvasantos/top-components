import QtQuick 2.2

Rectangle {
    color: "transparent"
    anchors.fill: parent

    property string mediaDir
    property string mediaSource
    property int detailsHeight

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
        width: parent.width
        height: parent.height - detailsHeight
        source: mediaDir + "/" + mediaSource
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: false
    }

    Flow {
        id: mediaDetailsRect
        width: parent.width
        height: detailsHeight - anchors.topMargin
        spacing: 10

        anchors {
            top: image.bottom
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
            spacing: 10

            Text {
                text: "Resolution:"
                color: "white"
                font.pixelSize: 15
                opacity: .6
            }

            Text {
                text: image.status == Image.Ready ? image.sourceSize.width + " x " + image.sourceSize.height : "? x ?"
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
