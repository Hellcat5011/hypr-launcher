import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 800; height: 600
        color: "blue" // Background

        // This mask will be stretched because it only contains a small rect!
        Item {
            id: mask1
            anchors.fill: parent
            layer.enabled: true
            visible: false
            
            Rectangle {
                x: 100; y: 100; width: 100; height: 50
                color: "white"
            }
        }
        
        // MultiEffect using the stretched mask
        MultiEffect {
            anchors.fill: parent
            source: Rectangle { color: "red"; width: 800; height: 600 }
            maskEnabled: true
            maskSource: mask1
        }
        
        Component.onCompleted: Quickshell.exit(0)
    }
}
