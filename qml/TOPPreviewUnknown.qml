import QtQuick 2.2

Rectangle {
    anchors.fill: parent
    color: "transparent"

    property string mediaDir
    property string mediaSource
    property int detailsHeight

    Rectangle {
        id: unknownHolder
        width: parent.width
        height: parent.height - detailsHeight
        color: "#222222"

        Image {
            id: icon
            width: 80
            height: width
            fillMode: Image.PreserveAspectFit
            source: "qrc:/components/images/unknown"

            anchors.centerIn: parent
        }
    }

    Flow {
        id: mediaDetailsRect
        width: parent.width
        height: detailsHeight - anchors.topMargin
        spacing: 10

        anchors {
            top: unknownHolder.bottom
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
                    focus: true
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

