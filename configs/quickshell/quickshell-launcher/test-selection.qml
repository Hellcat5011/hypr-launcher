import Quickshell
import QtQuick
import QtQuick.Effects

ShellRoot {
    PanelWindow {
        width: 800; height: 600
        color: "blue"
        
        property bool isSelectionActive: true
        property bool shown: true
        property bool hasContent: true
        property bool captureInProgress: false
        
        property real selX: 100
        property real selY: 100
        property real selW: 200
        property real selH: 200
        
        Item {
            id: overlayMask
            anchors.fill: parent
            visible: shown && hasContent && !captureInProgress && isSelectionActive
            opacity: shown ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
            
            property real holeX: selX
            property real holeY: selY
            property real holeW: selW
            property real holeH: selH
            property color maskColor: Qt.rgba(0, 0, 0, 0.55)
            
            Rectangle { x: 0; y: 0; width: parent.width; height: parent.holeY; color: parent.maskColor }
            Rectangle { x: 0; y: parent.holeY + parent.holeH; width: parent.width; height: parent.height - (parent.holeY + parent.holeH); color: parent.maskColor }
            Rectangle { x: 0; y: parent.holeY; width: parent.holeX; height: parent.holeH; color: parent.maskColor }
            Rectangle { x: parent.holeX + parent.holeW; y: parent.holeY; width: parent.width - (parent.holeX + parent.holeW); height: parent.holeH; color: parent.maskColor }
        }
        
        Component.onCompleted: Quickshell.exit(0)
    }
}
