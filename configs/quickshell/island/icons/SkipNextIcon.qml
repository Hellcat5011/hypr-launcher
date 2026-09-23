import QtQuick
import "../services"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24
    property color tint: Theme.pillForeground
    property real level: 1.0

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.fillStyle = root.tint;
            ctx.beginPath();
            ctx.moveTo(6, 6);
            ctx.lineTo(14, 12);
            ctx.lineTo(6, 18);
            ctx.closePath();
            ctx.fill();
            
            ctx.beginPath();
            ctx.rect(15, 6, 3, 12);
            ctx.fill();
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
