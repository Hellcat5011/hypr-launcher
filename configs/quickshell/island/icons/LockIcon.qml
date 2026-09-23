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
            ctx.reset(); ctx.clearRect(0, 0, width, height); ctx.scale(width / 24, height / 24);
            ctx.strokeStyle = root.tint;
            ctx.fillStyle = root.tint;
            ctx.lineWidth = 1.5;
            
            ctx.beginPath();
            // Draw rounded rect manually
            ctx.moveTo(8, 10);
            ctx.lineTo(16, 10);
            ctx.arcTo(18, 10, 18, 12, 2);
            ctx.lineTo(18, 18);
            ctx.arcTo(18, 20, 16, 20, 2);
            ctx.lineTo(8, 20);
            ctx.arcTo(6, 20, 6, 18, 2);
            ctx.lineTo(6, 12);
            ctx.arcTo(6, 10, 8, 10, 2);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.arc(12, 10, 4, Math.PI, 0);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.arc(12, 14, 1.5, 0, Math.PI*2);
            ctx.fill();
            ctx.beginPath();
            ctx.moveTo(12, 14);
            ctx.lineTo(12, 17);
            ctx.stroke();
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
