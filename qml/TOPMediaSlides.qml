import QtQuick 2.2
import TOP.Interactive 1.0

Rectangle {
    id: mediaSlidesHolder
    color: "transparent"

    property variant slidesModel
    property string searchFilter
    property string typeFilter
    property int detailsHeight: 100
    property var selectedMedia: []

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
        }

        onCurrentIndexChanged: {
            //            mediaSlides.highlightMoveDuration = 400
            mediaSlides.currentIndex = currentIndex
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
        height: miniView.height + 5
        color: "transparent"
        border.width: 3
        border.color: "#0099FF"
        radius: 5

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

            Loader {
                id: slideLoader
                width: parent.width
                height: parent.height

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
                    item.detailsHeight = detailsHeight
                }
            }
        }

        onCurrentIndexChanged: {
            miniView.currentIndex = currentIndex
        }

        Component.onCompleted: {
            if(selectedMedia.length > 0) {
                currentIndex = selectedMedia[selectedMedia.length - 1]
                miniView.currentIndex = currentIndex
            }
            else {
                currentIndex = 0
                miniView.currentIndex = 0
            }
        }
    }
}
