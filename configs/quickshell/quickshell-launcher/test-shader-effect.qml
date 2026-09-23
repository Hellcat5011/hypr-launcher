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
        
        ShaderEffectSource {
            id: blurredBg
            sourceItem: bg
            anchors.fill: parent
            visible: false
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 32
                blur: 1.0
            }
        }
        
        Rectangle {
            id: myPanel
            x: 100; y: 100
            width: 200; height: 50
            color: Qt.rgba(1,1,1,0.2)
            
            ShaderEffectSource {
                anchors.fill: parent
                sourceItem: blurredBg
                sourceRect: Qt.rect(myPanel.x, myPanel.y, myPanel.width, myPanel.height)
            }
        }
        
        Component.onCompleted: Quickshell.exit(0)
    }
}
