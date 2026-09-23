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
            ctx.lineJoin = 'round';
            
            ctx.beginPath();
            ctx.moveTo(12, 5);
            ctx.lineTo(6, 5);
            ctx.lineTo(6, 19);
            ctx.lineTo(12, 19);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(10, 12);
            ctx.lineTo(18, 12);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(15, 9);
            ctx.lineTo(18, 12);
            ctx.lineTo(15, 15);
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
