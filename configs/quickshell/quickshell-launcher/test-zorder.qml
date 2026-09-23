import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 800; height: 600
        color: "transparent"

        // The hidden blurred item, kept visible but sent to the back
        ShaderEffectSource {
            id: blurredBg
            anchors.fill: parent
            sourceItem: foreground
            z: -100 // Behind everything!
            visible: true
            layer.enabled: true
            layer.effect: MultiEffect { blurEnabled: true; blurMax: 32; blur: 1.0 }
        }

        // The opaque foreground that hides the blurred item
        Rectangle {
            id: foreground
            anchors.fill: parent
            color: "red"
            z: 0
        }

        // The UI panel that samples the blurred item
        ShaderEffectSource {
            sourceItem: blurredBg
            sourceRect: Qt.rect(100, 100, 200, 200)
            x: 100; y: 100; width: 200; height: 200
            z: 10 // On top of foreground
        }
        
        Component.onCompleted: Quickshell.exit(0)
    }
}
