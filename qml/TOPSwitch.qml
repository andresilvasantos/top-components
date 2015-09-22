import QtQuick 2.2

Item {
    id: toggleSwitch
    width: childrenRect.width

    property bool on: false
    property color fillColor: "#32C387"
    property color backgroundColor: "#111111"
    property string labelText
    property color labelColor: "white"
    property string labelFont: "Arial Narrow"
    property int labelPixelSize: 12
    property bool labelRightSide: true
    property color borderColor: "#444444"
    property color knobColor: "white"
    property int knobBorderWidth: 0

    signal toggled()
    signal entered()
    signal exited()

    function toggle() {
        if (toggleSwitch.state == "on")
            toggleSwitch.state = "off";
        else 
            toggleSwitch.state = "on";

        toggled()
    }

    function releaseSwitch() {
        if (knob.x == background.x) {
            if (toggleSwitch.state == "off") return;
        }
        if (knob.x == (toggleSwitch.width - knob.width)) {
            if (toggleSwitch.state == "on") return;
        }
        toggle();
    }

    Rectangle {
        id: background
        width: height * 2
        height: parent.height
        color: backgroundColor
        border.color: borderColor
        border.width: 1
        radius: 20

        anchors {
            left: labelRightSide ? undefined : label.right
            leftMargin: labelRightSide ? 0 : 10
        }

        MouseArea{
            anchors.fill: parent
            onClicked: toggle()
        }
    }

    Rectangle {
        id: knob
        width: height
        height: parent.height
        radius: width * 0.5
        color: knobColor
        border.width: knobBorderWidth
        border.color: fillColor
        x: background.x

        MouseArea {
            anchors.fill: parent
            drag.target: knob; drag.axis: Drag.XAxis; drag.minimumX: background.x; drag.maximumX: background.x + background.width - knob.width
            onClicked: toggle()
            onReleased: releaseSwitch()
            hoverEnabled: true

            onEntered: {
                toggleSwitch.entered()
            }

            onExited: {
                toggleSwitch.exited()
            }
        }
    }

    Text {
        id: label
        text: labelText
        color: labelColor
        font.pixelSize: labelPixelSize
        font.family: labelFont

        anchors {
            left: labelRightSide ? background.right : undefined
            leftMargin: labelRightSide ? 10 : 0
            verticalCenter: parent.verticalCenter
        }
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: knob; x: background.width - knob.width + background.x}
            PropertyChanges { target: background; color: fillColor }
            PropertyChanges { target: toggleSwitch; on: true }
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: background.x}
            PropertyChanges { target: background; color: backgroundColor }
            PropertyChanges { target: toggleSwitch; on: false }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 200 }
        ColorAnimation { target: background; properties: "color"; easing.type: Easing.InOutQuad; duration: 200 }
    }

    Component.onCompleted: {
        if(toggleSwitch.on)
            toggleSwitch.state = "on";
        else
            toggleSwitch.state = "off";
    }
}
