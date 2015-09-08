import QtQuick 2.2
import QtQuick.Window 2.0
import TOP.Interactive 1.0
import TOP.Utils 1.0

Rectangle {
    id: mediaSelector
    width: 140
    height: width
    radius: 5
    color: "#333333"

    property string mediaPath
    property string mediaAlias
    property string mediaType

    function updateModel(document)
    {
        var obj = JSON.parse(JsonHelper.docToString(document));
        var attachments = obj["attachments"];

        var toRemoveElements = new Array;
        for(var i = 0; i < mediaModel.count; ++i)
        {
            var element = mediaModel.get(i)

            if(attachments.hasOwnProperty(element.mediaPath) && element.mediaAlias == attachments[element.mediaPath]["alias"]) {
                delete attachments[element.mediaPath]
                continue;
            }

            toRemoveElements.push(i);
        }

        for(i = 0; i < toRemoveElements.length; ++i) {
            mediaModel.remove(toRemoveElements[i])
        }

        i = 0;
        for (var attachment in attachments) {
            var att = attachments[attachment]

            var mediaAlias = att["alias"]
            var mediaType = att["type"]
            var mediaSize = att["sizemb"]

            if(!mediaAlias) mediaAlias = "?"
            if(!mediaSize) mediaSize = "?"


            if(mediaType === "video") {
                var videoResolution = att["resolution"]
                var videoFramerate = att["videoframerate"]
                var videoCodec = att["videocodec"]
                var videoDuration = att["duration"]

                if(!videoResolution) videoResolution = "?"
                if(!videoFramerate) videoFramerate = "?"
                if(!videoCodec) videoCodec = "?"
                if(!videoDuration) videoDuration = "?"
                else videoDuration = parseInt(videoDuration)

                mediaModel.append({"mediaPath": attachment, "mediaAlias": mediaAlias, "mediaType": mediaType, "mediaSize": mediaSize,
                                   "uploadCompleted": true, "videoResolution": videoResolution,
                                   "videoFrameRate": videoFramerate, "videoCodec": videoCodec, "videoDuration": videoDuration})
            }
            else if(mediaType === "audio") {
                var audioSampleRate = att["samplerate"]
                var audioCodec = att["audiocodec"]
                var audioDuration = att["duration"]

                if(!audioSampleRate) audioSampleRate = "?"
                if(!audioCodec) audioCodec = "?"
                if(!audioDuration) audioDuration = "?"
                else audioDuration = parseInt(audioDuration)

                mediaModel.append({"mediaPath": attachment, "mediaAlias": mediaAlias, "mediaType": mediaType, "mediaSize": mediaSize,
                                   "uploadCompleted": true, "audioSampleRate": audioSampleRate,
                                   "audioCodec": audioCodec,"audioDuration": audioDuration})
            }
            else {
                mediaModel.append({"mediaPath": attachment, "mediaAlias": mediaAlias, "mediaType": mediaType,
                                   "mediaSize": mediaSize, "uploadCompleted": true})
            }

            ++i;
        }

        mediaModel.quick_sort()
    }

    TOPListModel {
        id: mediaModel
        sortColumnName: "mediaAlias"

        property string path: "http://127.0.0.1:5984/" + UserManager.databaseName() + "/media"
    }

    Image {
        id: imageTransparent
        fillMode: Image.Tile
        sourceSize.width: 300
        sourceSize.height: 300
        asynchronous: true
        source: "qrc:/components/images/transparency"
        cache: true
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignTop

        anchors.fill: mediaLoader
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
            if(mediaType.length === 0) {
                return ""
            }
            else if(mediaType == "image")
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
            item.mediaSource = mediaModel.path + "/" + mediaPath
            item.mediaAlias = mediaAlias

            if(mediaType == "image") item.aspectFill = false
        }
    }

    Text {
        id: textAlias
        text: mediaAlias
        color: "white"
        width: parent.width - 10
        elide: Text.ElideMiddle
        horizontalAlignment: Text.AlignHCenter

        anchors {
            bottom: parent.bottom
            bottomMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mediaPopup.visible = true
        }
    }

    Window {
        id: mediaPopup
        width: 640
        height: 480
        visible: false
        modality: Qt.WindowModal
        title: "Please select media"
        color: "#111111"

        signal accepted(int mediaIndex)
        signal rejected()

        Rectangle {
            id: searchRect
            width: 160
            height: 25
            color: "white"
            radius: 5

            anchors {
                top: parent.top
                topMargin: 5
                right: parent.right
                rightMargin: 5
            }

            TextInput {
                id: searchText
                color: "#111111"
                font.pixelSize: 13
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                selectByMouse: true
                selectionColor: "#333333"
                clip: true

                anchors {
                    fill: parent

                    leftMargin: 5
                    rightMargin: 5
                }

                onTextChanged: {
                    mediaGrid.contentY = 0
                }
            }
        }

        TOPMediaGrid {
            id: mediaGrid
            width: parent.width
            readyToLoad: true

            contentWidth: width

            anchors {
                top: searchRect.bottom
                topMargin: 5
                bottom: bottomBar.top
                bottomMargin: 5
                horizontalCenter: parent.horizontalCenter
            }

            gridModel: mediaModel
            searchFilter: searchText.text
            typeFilter: ""
            singleSelection: true

            Behavior on contentY {
                NumberAnimation {duration: 250; easing.type: Easing.OutSine}
            }
        }

        Item {
            id: bottomBar
            width: parent.width
            height: 30

            anchors {
                bottom: parent.bottom
                bottomMargin: 5
            }

            TOPButton {
                id: buttonCancel
                width: 80
                height: parent.height
                color: "#212121"
                hoverColor: "#002E4C"
                selectedColor: "#0099FF"
                radius: 5

                anchors {
                    right: buttonOK.left
                    rightMargin: 10

                    verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "CANCEL"
                    color: "white"

                    anchors.centerIn: parent
                }

                onClicked: {
                    mediaPopup.rejected()
                    mediaPopup.close()
                }
            }

            TOPButton {
                id: buttonOK
                width: 80
                height: parent.height
                color: "#212121"
                hoverColor: "#002E4C"
                selectedColor: "#0099FF"
                radius: 5

                anchors {
                    right: parent.right
                    rightMargin: 5

                    verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "OK"
                    color: "white"

                    anchors.centerIn: parent
                }

                onClicked: {
                    mediaPopup.accepted(mediaGrid.currentSelection)
                    mediaPopup.close()
                }
            }
        }

        onVisibleChanged: {
            if(visible)
            {
                updateModel(MediaManager.document())
            }
        }
    }

    Connections {
        target: mediaPopup
        ignoreUnknownSignals: true

        onAccepted: {
            var element = mediaModel.get(mediaIndex)
            console.log(element.mediaPath + "  " + element.mediaAlias)

            mediaPath = element.mediaPath
        }
    }

    onMediaPathChanged: {
        mediaAlias = MediaManager.mediaAttribute(mediaPath, "alias")
        mediaType = MediaManager.mediaAttribute(mediaPath, "type")

        if(mediaLoader.item)
        {
            mediaLoader.item.mediaSource = mediaModel.path + "/" + mediaPath
            mediaLoader.item.mediaAlias = mediaAlias
        }
    }
}
