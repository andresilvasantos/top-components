import QtQuick 2.5

Flickable {
    id: mainRect
    contentHeight: mediaGrid.height

    clip: true

    property variant gridModel
    property string searchFilter
    property string typeFilter
    property bool readyToLoad: true
    property bool singleSelection: false
    property int currentSelection: -1
    property bool mediaGallery: true
    property bool clearSelectedMedia: false

    signal mediaSelected(int index)
    signal mediaUnselected(int index)
    signal mediaRequested(int index)

    function clearSelection() {
        clearSelectedMedia = true
        clearSelectedMedia = false
    }

    Grid {
        id: mediaGrid
        width: parent.width
        height: childrenRect.height + 40
        rowSpacing: 10
        columnSpacing: 10

        property int cellSize: 140

        columns: {
            return Math.floor(width / 150)
        }

//        add: Transition {
//            NumberAnimation { properties: "x,y"; duration: 200; easing.type: Easing.OutSine }
//        }

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 200; easing.type: Easing.OutSine }
        }

        onWidthChanged: {
            updateCellSizeTimer.restart()
        }

        function updateCellSize() {
            cellSize = 140 + (width % (columns * 140 + columnSpacing * (columns - 1))) / columns
        }

        Timer {
            id: updateCellSizeTimer
            interval: 200

            onTriggered: {
                mediaGrid.updateCellSize()
            }
        }

        Repeater {
            model: gridModel
            delegate: Rectangle {
                id: mediaRect
                width: mediaGrid.cellSize
                height: mediaGrid.cellSize
                color: "transparent"

                visible: {
                    return ((searchFilter.length == 0 || mediaAlias.toLowerCase().indexOf(searchFilter.toLowerCase()) > -1) &&
                            (typeFilter.length == 0 || mediaType == typeFilter))
                }

                property bool clearSelection: mainRect.clearSelectedMedia
                property bool selected: {
                    if(singleSelection && currentSelection == index) return true
                    return false
                }

                onClearSelectionChanged: {
                    if(clearSelection && !singleSelection) {
                        selected = false
                    }
                }

                /*Rectangle {
                    id: mediaShadow
                    width: mediaLoader.width + 6
                    height: mediaLoader.height + 6
                    color: selected ? "transparent" : "#33000000"
                    radius: 10
                    //visible: mediaLoader.item ? mediaLoader.item.loaded : false

                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                }*/

                Rectangle {
                    id: mediaSelectionRect
                    width: mediaLoader.width + 6
                    height: mediaLoader.height + 6
                    color: "transparent"
                    radius: 5
                    border.color: selected ? "#0099FF" : "transparent"
                    border.width: selected ? 5 : 0

                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Loader {
                    id: mediaLoader
//                    focus: true
                    width: parent.width - 6
                    height: parent.height - textAlias.height - 10

                    anchors {
                        top: parent.top
                        topMargin: 3
                        horizontalCenter: parent.horizontalCenter
                    }

                    source: {
                        if(mediaGallery) {
                            if(!uploadCompleted || !readyToLoad) return "";

                            if(mediaType == "image")
                            {
                                return "TOPThumbnailImage.qml"
                            }
                            else if(mediaType == "video")
                            {
                                return "TOPThumbnailVideo.qml"
                            }
                            else if(mediaType == "audio")
                            {
                                return "TOPThumbnailAudio.qml"
                            }
                            else
                            {
                                return "TOPThumbnailUnknown.qml"
                            }
                        }
                        else {
                            return "TOPThumbnailImage.qml"
                        }
                    }

                    onLoaded: {
                        if(gridModel.path) item.mediaSource = gridModel.path + "/" + mediaPath
                        else item.mediaSource = mediaPath

                        item.mediaAlias = mediaAlias
                        thumbnailConnections.target = item
                    }
                }

                Connections {
                    id: thumbnailConnections
                    ignoreUnknownSignals: true

                    onClicked: {
                        if(singleSelection) {
//                            mediaRect.selected = true
                            currentSelection = index
                        }
                        else {
                            mediaRect.selected = !mediaRect.selected
                            if(mediaRect.selected) mediaSelected(index)
                            else mediaUnselected(index)
                        }
                    }

                    onDoubleClicked: {
                        mediaRequested(index)
                    }
                }

                Text {
                    id: textAlias
                    text: mediaAlias
                    color: "#888888"
                    elide: Text.ElideMiddle

                    anchors {
                        top: mediaLoader.bottom
                        topMargin: 8
                        left: parent.left
                        leftMargin: 4
                        right: parent.right
                        rightMargin: 4
                    }
                }
            }
        }
    }
}
