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
            ctx.lineWidth = 1.5;
            ctx.lineCap = 'round';
            
            ctx.beginPath();
            ctx.arc(12, 12, 6, -Math.PI/2 + 0.5, Math.PI*1.5 - 0.5);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(12, 5);
            ctx.lineTo(12, 12);
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
