import QtQuick 2.5

Flickable {
    contentHeight: pluginsGrid.height

    clip: true

    property variant gridModel
    property string searchFilter
    property bool readyToLoad: false
    property bool singleSelection: false
    property int currentSelection: -1

    signal pluginSelected(int index)
    signal pluginUnselected(int index)

    Grid {
        id: pluginsGrid
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
                id: pluginRect
                width: pluginsGrid.cellSize
                height: pluginsGrid.cellSize
                color: "transparent"

                visible: {
                    return (searchFilter.length == 0 || pluginName.toLowerCase().indexOf(searchFilter.toLowerCase()) > -1)
                }

                property bool selected: {
                    if(singleSelection && currentSelection == index) return true
                    return false
                }

                Rectangle {
                    id: pluginShadow
                    width: pluginThumbnail.width + 6
                    height: pluginThumbnail.height + 6
                    color: selected ? "transparent" : "#33000000"
                    radius: 10

                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle {
                    id: pluginSelectionRect
                    width: pluginThumbnail.width + 6
                    height: pluginThumbnail.height + 6
                    color: "transparent"
                    radius: 5
                    border.color: selected ? "#0099FF" : "transparent"
                    border.width: selected ? 5 : 0

                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle {
                    id: pluginThumbnail
                    width: parent.width - 6
                    height: parent.height - textAlias.height - 10
                    color: "#212121"

                    anchors {
                        top: parent.top
                        topMargin: 3
                        horizontalCenter: parent.horizontalCenter
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if(singleSelection) {
    //                            mediaRect.selected = true
                                currentSelection = index
                            }
                            else {
                                pluginRect.selected = !pluginRect.selected
                                if(pluginRect.selected) pluginSelected(index)
                                else pluginUnselected(index)
                            }
                        }
                    }
                }

                Text {
                    id: textAlias
                    text: pluginName
                    color: "white"
                    clip: true
                    width: parent.width
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter

                    anchors {
                        top: pluginThumbnail.bottom
                        topMargin: 8
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
}
