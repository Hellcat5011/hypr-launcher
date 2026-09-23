import QtQuick
import "../services"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    property color tint: Theme.pillForeground
    property real level: 1.0
    property bool muted: false

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            
            ctx.strokeStyle = root.tint;
            ctx.fillStyle = root.tint;
            ctx.lineWidth = 1.5;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            
            ctx.beginPath();
            ctx.moveTo(6, 9);
            ctx.lineTo(10, 9);
            ctx.lineTo(15, 4);
            ctx.lineTo(15, 20);
            ctx.lineTo(10, 15);
            ctx.lineTo(6, 15);
            ctx.closePath();
            ctx.stroke();
            ctx.fill();
            
            if (root.muted) {
                ctx.beginPath();
                ctx.moveTo(18, 9);
                ctx.lineTo(22, 15);
                ctx.moveTo(22, 9);
                ctx.lineTo(18, 15);
                ctx.stroke();
            } else {
                let waves = 0;
                if (root.level > 0.05) waves = 1;
                if (root.level > 0.33) waves = 2;
                if (root.level > 0.66) waves = 3;
                
                if (waves > 0) {
                    ctx.beginPath();
                    ctx.arc(15, 12, 4, -Math.PI/4, Math.PI/4);
                    ctx.stroke();
                }
                if (waves > 1) {
                    ctx.beginPath();
                    ctx.arc(15, 12, 7, -Math.PI/4, Math.PI/4);
                    ctx.stroke();
                }
                if (waves > 2) {
                    ctx.beginPath();
                    ctx.arc(15, 12, 10, -Math.PI/4, Math.PI/4);
                    ctx.stroke();
                }
            }
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onLevelChanged() { canvas.requestPaint(); }
            function onMutedChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
