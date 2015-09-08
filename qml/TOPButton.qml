import QtQuick 2.2

Item {
    id: container

    signal clicked
    property string text
    property string color
    property string hoverColor: color
    property string selectedColor: color
    property string textColor
    property string textSelectedColor: textColor
    property int textSize: 12
    property string textFamily: "Arrial Narrow"
    property bool checkable: false
    property bool checked: false
    property int radius
    property int borderWidth: 0
    property string borderColor: color

    Rectangle {
        id: buttonRectangle
        width: container.width
        height: container.height
        color: container.color
        radius: container.radius
        border.width: borderWidth
        border.color: borderColor

        MouseArea {
            id: mouseArea;
            anchors.fill: parent
            hoverEnabled: true

            onExited: {
                if(!checkable || !checked) buttonRectangle.state = "default"
            }

            onEntered: {
                if(!checked) buttonRectangle.state = "hovered"
            }

            onClicked: {
                buttonRectangle.state = "pressed"
                container.clicked()

                if(!checkable) stateTimer.start()
            }
        }

        Text {
            id: buttonText
            color: container.textColor
            anchors.centerIn: buttonRectangle
            font.pixelSize: textSize
            font.family: textFamily
            text: container.text

            transitions: Transition {
                ColorAnimation { properties: "color"; duration: 200; easing.type: Easing.InOutQuad }
            }
        }

        states: [
            State {
                name: "hovered"
                PropertyChanges { target: buttonRectangle; color: container.hoverColor }
            }
            ,State {
                name: "pressed"
                PropertyChanges { target: buttonRectangle; color: container.selectedColor }
                PropertyChanges { target: buttonText; color: container.textSelectedColor }
            }
        ]

        Timer {
            id: stateTimer
            interval: 200;
            repeat: false
            onTriggered: buttonRectangle.state = "default"
        }

        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 200; easing.type: Easing.InOutQuad }
        }
    }

    onCheckedChanged: {
        if(checked)
        {
            buttonRectangle.state = "pressed"
        }
        else
        {
            buttonRectangle.state = "default"
        }
    }
}
