import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 400; height: 400
        color: "transparent"
        
        Rectangle {
            id: bg
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "red" }
                GradientStop { position: 1.0; color: "blue" }
            }
        }
        
        Item {
            id: blurMask
            anchors.fill: parent
            layer.enabled: true
            visible: false
            
            Rectangle {
                id: barMask
                x: 100; y: 100; width: 200; height: 50; color: "white"
            }
        }
        
        MultiEffect {
            source: bg
            anchors.fill: parent
            blurEnabled: true
            blurMax: 32
            blur: 1.0
            maskEnabled: true
            maskSource: blurMask
        }
        
        Component.onCompleted: Quickshell.exit(0)
    }
}
