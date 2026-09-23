import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 400; height: 400
        Rectangle {
            id: bg
            anchors.fill: parent
            color: "red"
        }
        MultiEffect {
            anchors.fill: bg
            source: bg
            blurEnabled: true
            blurMax: 32
            blur: 1.0
        }
        Component.onCompleted: Quickshell.exit(0)
    }
}
