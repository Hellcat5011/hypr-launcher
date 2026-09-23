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
            ctx.fillStyle = root.tint;
            
            ctx.beginPath();
            ctx.arc(12, 12, 7, 0, Math.PI*2);
            ctx.fill();
            
            ctx.globalCompositeOperation = 'destination-out';
            ctx.beginPath();
            ctx.arc(15, 9, 6, 0, Math.PI*2);
            ctx.fill();
            
            ctx.globalCompositeOperation = 'source-over';
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
