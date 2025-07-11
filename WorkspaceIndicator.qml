import QtQuick 6.3
import QtQuick.Layouts 1.3
import Quickshell.Hyprland
import "./js/colors.js" as C

Item {
    id: workspaceIndicator
    // Size of each workspace bubble
    property int indicatorSize: 30

    // User-configurable properties
    property int shown: 5
    property bool rounded: true
    property bool activeIndicator: true
    property bool occupiedBg: false
    property bool showWindows: true
    property bool activeTrail: true
    property string label: "  "
    property string occupiedLabel: "󰮯 "
    property string activeLabel: " "

    RowLayout {
        anchors.fill: parent
        spacing: 4
        
        Repeater {
            model: Hyprland.workspaces

            delegate: MouseArea {
                width: indicatorSize
                height: indicatorSize
                hoverEnabled: showWindows

                onClicked: Quickshell.Hyprland.dispatch(`dispatch workspace ${modelData.id}`)

                Rectangle {
                    anchors.fill: parent
                    radius: rounded ? indicatorSize/2 : 0
                    color: Hyprland.focusedWorkspace === modelData
                        ? C.foreground
                        : (occupiedBg && modelData.lastIpcObject.windowCount > 0)
                            ? C.warning
                            : C.info
                    border.width: activeIndicator && Hyprland.focusedWorkspace === modelData ? 2 : 0
                    border.color: activeIndicator ? C.warning : C.alert
                    Text {
                        anchors.centerIn: parent
                        text: Hyprland.focusedWorkspace === modelData
                            ? activeLabel
                            : (modelData.lastIpcObject && modelData.lastIpcObject.windowCount > 0)
                                ? occupiedLabel
                                : label
                        font.pixelSize: indicatorSize * 0.6
                    }
                }
            }
        }
    }
}
