import QtQuick 2.2

Rectangle {
    id: root
    color: "transparent"
    radius: 5

    property alias value: grip.value
    property color backgroundColor: "white"
    property color fillColor: "#14aaff"
    property color gripColor: "#212121"
    property real gripSize: 15
    property real gripTolerance: 3.0
    property int gripBorderWidth: 1
    property real increment: 0.1
    property bool enabled: true

    signal sliderMoved()
    signal sliderReleased()

    Rectangle {
        id: slider
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: 10
        color: "transparent"

        Rectangle {
           id: backgroundSlider
           color: backgroundColor
           anchors.fill: parent
           radius: width/2

           MouseArea {
               enabled: root.enabled
               anchors.fill:  parent

               onClicked: {
                   value = mouse.x / width
                   sliderMoved()
                   sliderReleased()
               }
           }
        }

        Rectangle {
            height: parent.height -2
            anchors.left: parent.left
            anchors.right: grip.horizontalCenter
            color: fillColor
            radius: 3
            border.width: 1
            border.color: Qt.darker(color, 1.3)
            opacity: 0.8
        }

        Rectangle {
            id: grip
            x: (value * parent.width) - width/2
            width: root.gripTolerance * root.gripSize
            height: width
            radius: width/2
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter

            property real value: 0

            Rectangle {
                id: sliderHandle
                width: gripSize
                height: gripSize
                radius: width/2
                color: gripColor
                border.width: gripBorderWidth
                border.color: fillColor

                anchors.centerIn: parent
            }

            MouseArea {
                enabled: root.enabled
                anchors {
                    fill:  parent
                }

                drag {
                    target: grip
                    axis: Drag.XAxis
                    minimumX: -parent.width/2
                    maximumX: root.width - parent.width/2
                }

                onPositionChanged:  {
                    if(drag.active) updatePosition()
                    sliderMoved()
                }

                onReleased: {
                    updatePosition()
                    sliderReleased()
                }

                onClicked: {
                    value = (mouse.x + grip.width/2) / slider.width
                    sliderReleased()
                }

                function updatePosition() {
                    value = (grip.x + grip.width/2) / slider.width
                }
            }
        }
    }
}

