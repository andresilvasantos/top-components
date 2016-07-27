import QtQuick 2.5

Item {
    id: scrollbar;
    width: enlargeEnabled && (groove.hovered || clicker.drag.active || clicker.pressed) ? handleExpandedSize : handleSize
    visible: (flickable.visibleArea.heightRatio < 1.0);
    opacity: 0

    Behavior on width {
        NumberAnimation {duration: 150}
    }

    property Flickable flickable: null;
    property int handleSize: 10;
    property int handleExpandedSize: 15;
    property bool visibleBackground: true
    property bool enlargeEnabled: true
    property string scrollBarImage: "qrc:/components/images/scrollbar"

    function scrollDown () {
        flickable.contentY = Math.min (flickable.contentY + (flickable.height / 4), flickable.contentHeight - flickable.height);
    }
    function scrollUp () {
        flickable.contentY = Math.max (flickable.contentY - (flickable.height / 4), 0);
    }

    Binding {
        target: handle;
        property: "y";
        value: ((flickable.contentY - flickable.originY) * clicker.drag.maximumY / (flickable.contentHeight - flickable.height));
        when: (!clicker.drag.active);
    }

    Binding {
        target: flickable;
        property: "contentY";
        value: flickable.originY + (handle.y * (flickable.contentHeight - flickable.height) / clicker.drag.maximumY)
        when: (clicker.drag.active || clicker.pressed);
    }

    Rectangle {
        id: groove;
        clip: true;
        color: visibleBackground ? "black" : "transparent"
        opacity: .1
        anchors {
            fill: parent;
        }

        property bool hovered: false

        MouseArea {
            id: clicker;
            hoverEnabled: true

            anchors.fill: parent

            drag {
                target: handle;
                minimumY: 0;
                maximumY: (scrollbar.height - handle.height);
                axis: Drag.YAxis;
            }

            onEntered: {
                groove.hovered = true
            }

            onExited: {
                groove.hovered = false
            }

            onPressed: {
                flickable.contentY = (mouse.y / groove.height * (flickable.contentHeight - flickable.height))
            }
        }
    }

    Item {
        id: handle;
        height: Math.max (20, (flickable.visibleArea.heightRatio * groove.height));
        anchors {
            left: groove.left;
            right: groove.right;
        }


        BorderImage {
            source: scrollBarImage
            border { left: 1; right: 1; top: 1; bottom: 1 }
            anchors{
                fill: parent
                margins: 1
            }
        }
    }

    states: State {
        name: "visible"
        when: flickable.moving || clicker.pressed || groove.hovered
        PropertyChanges { target: scrollbar; opacity: 1.0 }
    }

    transitions: Transition {
        from: "visible"; to: ""
        NumberAnimation {properties: "opacity"; duration: 600}
    }
}
