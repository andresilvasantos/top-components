import QtQuick 2.2

Rectangle {
    color: "#222222"

    property bool loaded: false
    property string mediaSource
    property string mediaAlias
    signal touched()

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
            touched()
        }
    }

    Component.onCompleted: {
        loaded = true
    }
}

