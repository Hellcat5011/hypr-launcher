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
            ctx.strokeStyle = root.tint;
            ctx.lineWidth = 1.5;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            
            ctx.beginPath();
            var cx = width / 2;
            ctx.moveTo(cx - width * 0.2, height * 0.25); // Top-left tail
            ctx.lineTo(cx, height * 0.5); // Center
            ctx.lineTo(cx + width * 0.25, height * 0.25); // Top-right tip
            ctx.lineTo(cx, height * 0.1); // Top tip
            ctx.lineTo(cx, height * 0.9); // Bottom tip
            ctx.lineTo(cx + width * 0.25, height * 0.75); // Bottom-right tip
            ctx.lineTo(cx, height * 0.5); // Center
            ctx.lineTo(cx - width * 0.2, height * 0.75); // Bottom-left tail
            
            ctx.stroke();
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onLevelChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
