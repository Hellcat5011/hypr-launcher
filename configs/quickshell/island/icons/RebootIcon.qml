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
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            
            ctx.beginPath();
            // Draw arc from Right (0) to Top (-90 degrees), clockwise
            ctx.arc(12, 12, 6, 0, -Math.PI/2, false);
            ctx.stroke();
            
            // Arrow head at Top (12,6), pointing Right
            ctx.beginPath();
            ctx.moveTo(11, 2);
            ctx.lineTo(16, 6);
            ctx.lineTo(11, 10);
            ctx.closePath();
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
