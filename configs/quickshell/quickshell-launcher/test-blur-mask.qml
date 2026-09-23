import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 600; height: 600
        color: "transparent"

        Rectangle {
            id: bg
            anchors.fill: parent
            color: "blue"
            
            Rectangle {
                anchors.centerIn: parent
                width: 200; height: 200
                color: "green"
            }
        }
        
        Item {
            id: blurMask
            anchors.fill: parent
            layer.enabled: true
            visible: false
            
            Rectangle {
                x: 100; y: 100
                width: 200; height: 50
                color: "white"
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
