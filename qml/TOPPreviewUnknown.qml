import QtQuick 2.5

Rectangle {
    anchors.fill: parent
    color: "transparent"

    property string mediaDir
    property string mediaSource

    Rectangle {
        id: unknownHolder
        anchors.fill: parent
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
}

