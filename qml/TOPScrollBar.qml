import QtQuick 2.0;

Item {
    id: scrollbar;
    width: (handleSize/* + 2 * (backScrollbar.border.width +1)*/);
    visible: (flickable.visibleArea.heightRatio < 1.0);
    anchors {
        top: flickable.top;
        right: flickable.right;
        bottom: flickable.bottom;
        margins: 1;
    }

    property Flickable flickable               : null;
    property int       handleSize              : 10;

    function scrollDown () {
        flickable.contentY = Math.min (flickable.contentY + (flickable.height / 4), flickable.contentHeight - flickable.height);
    }
    function scrollUp () {
        flickable.contentY = Math.max (flickable.contentY - (flickable.height / 4), 0);
    }

    Binding {
        target: handle;
        property: "y";
        value: ((flickable.contentY - flickable.originY) * (clicker.drag.maximumY) / (flickable.contentHeight - flickable.height));
        when: (!clicker.drag.active);
    }

    Binding {
        target: flickable;
        property: "contentY";
        value: (handle.y * (flickable.contentHeight - flickable.height) / (clicker.drag.maximumY)) + flickable.originY;
        when: (clicker.drag.active || clicker.pressed);
    }

    Item {
        id: groove;
        clip: true;
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
                maximumY: (flickable.height - handle.height);
                axis: Drag.YAxis;
            }

            onEntered: {
                groove.hovered = true
            }

            onExited: {
                groove.hovered = false
            }

            onClicked: {
                flickable.contentY = (mouse.y / groove.height * (flickable.contentHeight - flickable.height))
            }
        }

        Item {
            id: handle;
            height: Math.max (20, (flickable.visibleArea.heightRatio * groove.height));
            anchors {
                left: parent.left;
                right: parent.right;
            }

            Rectangle {
                id: backHandle;
                color: "black"
                opacity: flickable.moving || clicker.pressed || groove.hovered ? 0.65 : 0
                anchors.fill: parent
                radius: handleSize

                Behavior on opacity { NumberAnimation {duration: 150} }
            }
        }
    }
}
