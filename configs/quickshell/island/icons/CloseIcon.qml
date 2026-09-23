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
            
            ctx.beginPath();
            ctx.moveTo(7, 7);
            ctx.lineTo(17, 17);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(17, 7);
            ctx.lineTo(7, 17);
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
