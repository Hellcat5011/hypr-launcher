import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 400; height: 400
        color: "transparent"
        
        // Unblurred background (simulates ScreencopyView)
        Rectangle {
            id: bg
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "red" }
                GradientStop { position: 1.0; color: "blue" }
            }
        }
        
        // The mask (opaque where we want blur)
        Item {
            id: blurMask
            anchors.fill: parent
            visible: false
            Rectangle { anchors.fill: parent; color: "white" }
            Rectangle { x: 100; y: 100; width: 200; height: 200; color: "transparent"; renderType: Rectangle.Custom } // wait transparent over white won't make a hole unless we use blend modes!
        }
        
        Component.onCompleted: Quickshell.exit(0)
    }
}
