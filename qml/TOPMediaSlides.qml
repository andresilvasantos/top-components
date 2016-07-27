import QtQuick 2.5

Rectangle {
    id: mainRect
    color: "#212121"

    property variant slidesModel
    property string searchFilter
    property string typeFilter
    property int detailsHeight: 100
    property int currentIndex: 0

    signal mediaAliasUpdated(string mediaPath, string mediaAlias)

    onCurrentIndexChanged: {
        mediaSlides.currentIndex = mainRect.currentIndex
        miniView.currentIndex = mainRect.currentIndex
    }

    ListView {
        id: miniView
        width: parent.width
        height: 30
        orientation: ListView.Horizontal
        model: slidesModel
        spacing: 5

        preferredHighlightBegin: width / 2 - 15
        preferredHighlightEnd: width / 2 + 15
        highlightRangeMode: ListView.StrictlyEnforceRange

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 10
        }

        onCurrentIndexChanged: {
            mainRect.currentIndex = currentIndex
        }

        delegate: Rectangle {
            width: height
            height: 30
            color: mediaType == "image" ? "transparent" : "#444444"

            opacity: ((searchFilter.length == 0 || mediaAlias.toLowerCase().indexOf(searchFilter.toLowerCase()) > -1) &&
                        (typeFilter.length == 0 || mediaType == typeFilter)) ? 1: .2

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
                visible: mediaType == "image"

                anchors.fill: image
            }

            Image {
                id: image
                width: height
                height: mediaType == "image" ? parent.height : parent.height * .6
                fillMode: mediaType == "image" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
                sourceSize.width: mediaType == "image" ? 80 : width
                sourceSize.height: mediaType == "image" ? 80 : height
                asynchronous: true
                source: {
                    if(mediaType == "image") return slidesModel.path + "/" + mediaPath
                    else if(mediaType == "video") return "qrc:/components/images/video"
                    else if(mediaType == "audio") return "qrc:/components/images/sound"
                    else return "qrc:/components/images/unknown"
                }

                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    mediaSlides.highlightMoveDuration = 400
                    mediaSlides.currentIndex = index
                }
            }
        }
    }

    Rectangle {
        id: miniViewHighlight
        width: height
        height: miniView.height
        color: "transparent"
        border.width: 2
        border.color: "#0099FF"
        radius: 2

        anchors.centerIn: miniView
    }

    Rectangle {
        id: background
        color: "#090909"
        width: parent.width
        height: mediaSlides.height - detailsHeight

        anchors {
            top: miniView.bottom
            topMargin: 10
        }
    }

    ListView {
        id: mediaSlides
        width: parent.width
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
//        cacheBuffer: width * 5
        spacing: 10

        anchors {
            top: miniView.bottom
            topMargin: 10
            bottom: parent.bottom
        }

        highlight: Rectangle {color: "transparent";width: 80; height: 80}
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        preferredHighlightBegin: 0; preferredHighlightEnd: 0
        highlightRangeMode: ListView.StrictlyEnforceRange

        model: slidesModel

        delegate: Rectangle {
            width: mediaSlides.width
            height: mediaSlides.height
            color: "transparent"

            property bool inRange: mediaSlides.currentIndex == index

            onInRangeChanged: {
                if(slideLoader.item && mediaType == "video") slideLoader.item.inRange = inRange
            }

            Loader {
                id: slideLoader
                width: parent.width

                anchors {
                    top: parent.top
                    bottom: mediaDetailsRect.top
                }

                source: {
                    if(!uploadCompleted) return "TOPPreviewUnknown.qml"

                    if(mediaType == "image") {
                        return "TOPPreviewImage.qml"
                    }
                    else if(mediaType == "video") {
                        return "TOPPreviewVideo.qml"
                    }
                    else if(mediaType == "audio") {
                        return "TOPPreviewAudio.qml"
                    }
                    else {
                        return "TOPPreviewUnknown.qml"
                    }
                }

                onLoaded: {
                    item.mediaDir = mediaModel.path
                    item.mediaSource = mediaPath
                    //item.detailsHeight = detailsHeight
                    if(mediaType == "video" || mediaType == "audio") slideLoader.item.inRange = inRange
                }
            }


            Item {
                id: mediaDetailsRect
                width: parent.width
                height: detailsHeight// - anchors.topMargin

                anchors {
                    bottom: parent.bottom
                }

                Flow {
                    spacing: 10

                    anchors {
                        fill: parent
                        margins: 10
                    }

                    Row {
                        id: mediaAliasRow
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
                            radius: 2

                            TextInput {
                                id: mediaName
                                text: mediaAlias
                                color: "#212121"
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

                                onEditingFinished: {
                                    mediaAliasUpdated(mediaPath, mediaName.text)
                                }
                            }
                        }
                    }

                    Row {
                        id: imageResolutionRow
                        width: childrenRect.width
                        height: 30
                        spacing: 10
                        visible: mediaType == "image"

                        Text {
                            text: "Resolution:"
                            color: "white"
                            font.pixelSize: 15
                            opacity: .6
                        }

                        Text {
                            text: {
                                if(mediaType != "image") return ""

                                if(slideLoader.item) {
                                    var image = slideLoader.item.imageComponent
                                    if(image.status === Image.Ready) return image.sourceSize.width + " x " + image.sourceSize.height
                                }
                                return "? x ?"
                            }
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Row {
                        id: videoResolutionRow
                        width: childrenRect.width
                        height: 30
                        spacing: 5
                        visible: mediaType == "video"

                        Text {
                            text: "Resolution:"
                            color: "white"
                            font.pixelSize: 15
                            opacity: .6
                        }

                        Text {
                            text: mediaType == "video" ? videoResolution : ""
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Row {
                        id: videoCodecRow
                        width: childrenRect.width
                        height: 30
                        spacing: 5
                        visible: mediaType == "video"

                        Text {
                            text: "Codec:"
                            color: "white"
                            font.pixelSize: 15
                            opacity: .6
                        }

                        Text {
                            text: mediaType == "video" ? videoCodec : ""
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Row {
                        id: videoFrameRateRow
                        width: childrenRect.width
                        height: 30
                        spacing: 5
                        visible: mediaType == "video"

                        Text {
                            text: "Frame rate:"
                            color: "white"
                            font.pixelSize: 15
                            opacity: .6
                        }

                        Text {
                            text: mediaType == "video" ? videoFrameRate : ""
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Row {
                        id: audioCodecRow
                        width: childrenRect.width
                        height: 30
                        spacing: 5
                        visible: mediaType == "audio"

                        Text {
                            text: "Codec:"
                            color: "white"
                            font.pixelSize: 15
                            opacity: .6
                        }

                        Text {
                            text: mediaType == "audio" ? audioCodec : ""
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Row {
                        id: audioSampleRateRow
                        width: childrenRect.width
                        height: 30
                        spacing: 5
                        visible: mediaType == "audio"

                        Text {
                            text: "Sample rate:"
                            color: "white"
                            font.pixelSize: 15
                            opacity: .6
                        }

                        Text {
                            text: mediaType == "audio" ? audioSampleRate : ""
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Row {
                        id: mediaSizeRow
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
        }

        onCurrentIndexChanged: {
            miniView.currentIndex = currentIndex
        }
    }
}
