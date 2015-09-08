import QtQuick 2.2

Flickable {
    contentHeight: mediaGrid.height

    clip: true

    property variant gridModel
    property string searchFilter
    property string typeFilter
    property bool readyToLoad: false
    property bool singleSelection: false
    property int currentSelection: -1

    signal mediaSelected(int index)
    signal mediaUnselected(int index)

    Grid {
        id: mediaGrid
        width: parent.width
        height: childrenRect.height + 40
        rowSpacing: 10
        columnSpacing: 10

        property int cellSize: 140

        columns: {
            Math.floor(width / 150)
        }

        add: Transition {
            NumberAnimation { properties: "x,y"; duration: 200; easing.type: Easing.OutSine }
        }

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 200; easing.type: Easing.OutSine }
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

                property bool selected: {
                    if(singleSelection && currentSelection == index) return true
                    return false
                }

                Rectangle {
                    id: mediaShadow
                    width: mediaLoader.width + 6
                    height: mediaLoader.height + 6
                    color: selected ? "transparent" : "#33000000"
                    radius: 10
                    visible: mediaLoader.item ? mediaLoader.item.loaded : false

                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                }

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

                    onTouched: {
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
                }

                Text {
                    id: textAlias
                    text: mediaAlias
                    color: "white"
                    clip: true
                    width: parent.width
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter

                    anchors {
                        top: mediaLoader.bottom
                        topMargin: 8
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
}
