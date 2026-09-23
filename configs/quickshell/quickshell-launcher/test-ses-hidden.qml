import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 800; height: 600
        color: "transparent"
        
        Rectangle {
            id: src1
            anchors.fill: parent
            color: "red"
        }
        
        ShaderEffectSource {
            id: src2
            anchors.fill: parent
            sourceItem: src1
            visible: false
            layer.enabled: true
            layer.effect: MultiEffect { blurEnabled: true; blurMax: 32; blur: 1.0 }
        }
        
        ShaderEffectSource {
            anchors.fill: parent
            sourceItem: src2
            sourceRect: Qt.rect(100, 100, 200, 200)
            x: 100; y: 100; width: 200; height: 200
        }
    }
}
