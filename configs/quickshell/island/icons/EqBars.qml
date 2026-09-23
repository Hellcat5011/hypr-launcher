import QtQuick
import "../services"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24
    property color tint: Theme.pillForeground
    property real level: 1.0
    property bool active: false

    property real bar1H: 3
    property real bar2H: 3
    property real bar3H: 3

    Behavior on bar1H { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
    Behavior on bar2H { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    Behavior on bar3H { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }

    Timer {
        running: root.active
        repeat: true
        interval: 200
        onTriggered: {
            root.bar1H = 3 + Math.random() * 10;
        }
    }
    Timer {
        running: root.active
        repeat: true
        interval: 250
        onTriggered: {
            root.bar2H = 3 + Math.random() * 10;
        }
    }
    Timer {
        running: root.active
        repeat: true
        interval: 180
        onTriggered: {
            root.bar3H = 3 + Math.random() * 10;
        }
    }

    onActiveChanged: {
        if (!active) {
            bar1H = 3;
            bar2H = 3;
            bar3H = 3;
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.fillStyle = root.tint;
            
            let by = 18;
            
            ctx.beginPath();
            ctx.fillRect(6, by - root.bar1H, 2, root.bar1H);
            ctx.fillRect(11, by - root.bar2H, 2, root.bar2H);
            ctx.fillRect(16, by - root.bar3H, 2, root.bar3H);
            ctx.fill();
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onBar1HChanged() { canvas.requestPaint(); }
            function onBar2HChanged() { canvas.requestPaint(); }
            function onBar3HChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
