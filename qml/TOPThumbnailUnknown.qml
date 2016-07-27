import QtQuick 2.5

Item {
    id: mainRect

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
    }

    Image {
        id: icon
        width: 30
        height: width
        fillMode: Image.PreserveAspectFit
        source: "qrc:/components/images/unknown"

        anchors.centerIn: parent
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

    Component.onCompleted: {
        loaded = true
    }
}

