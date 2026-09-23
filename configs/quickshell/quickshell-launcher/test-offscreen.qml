import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 600; height: 600
        color: "transparent"

        Rectangle {
            id: src
            x: 99999 // Offscreen!
            width: 200; height: 200
            color: "red"
        }
        
        ShaderEffectSource {
            anchors.centerIn: parent
            width: 200; height: 200
            sourceItem: src
        }
        
        Component.onCompleted: Quickshell.exit(0)
    }
}
