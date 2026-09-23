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
            ctx.fillStyle = root.tint;
            ctx.lineWidth = 1.5;
            ctx.lineCap = 'round';
            
            let cx = width / 2;
            let cy = height / 2;
            let r = 3 + root.level * 3;
            
            ctx.beginPath();
            ctx.arc(cx, cy, r, 0, Math.PI * 2);
            ctx.stroke();
            
            let rayInner = r + 2;
            let rayOuter = rayInner + 1 + root.level * 4;
            
            for (let i = 0; i < 8; i++) {
                let angle = (i * Math.PI) / 4;
                let c = Math.cos(angle);
                let s = Math.sin(angle);
                
                ctx.beginPath();
                ctx.moveTo(cx + c * rayInner, cy + s * rayInner);
                ctx.lineTo(cx + c * rayOuter, cy + s * rayOuter);
                ctx.stroke();
            }
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
