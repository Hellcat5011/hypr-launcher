import QtQuick
import "../services"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24
    property color tint: Theme.pillForeground
    property real level: 1.0
    property bool hidden: false

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
            ctx.moveTo(3, 12);
            ctx.bezierCurveTo(9, 5, 15, 5, 21, 12);
            ctx.bezierCurveTo(15, 19, 9, 19, 3, 12);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.arc(12, 12, 3, 0, Math.PI*2);
            ctx.stroke();
            
            if (root.hidden) {
                ctx.beginPath();
                ctx.moveTo(4, 4);
                ctx.lineTo(20, 20);
                ctx.stroke();
            }
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onHiddenChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
