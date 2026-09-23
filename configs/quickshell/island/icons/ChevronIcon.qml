import QtQuick
import "../services"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24
    property color tint: Theme.pillForeground
    property real level: 1.0
    property string direction: 'right'

    Canvas {
        id: canvas
        anchors.fill: parent
        
        rotation: {
            if (root.direction === 'left') return 180;
            if (root.direction === 'up') return -90;
            if (root.direction === 'down') return 90;
            return 0; // right
        }
        
        Behavior on rotation {
            SpringAnimation {
                spring: Theme.springStiffness
                damping: Theme.springDamping
                epsilon: Theme.springEpsilon
            }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.strokeStyle = root.tint;
            ctx.lineWidth = 1.5;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            
            ctx.beginPath();
            ctx.moveTo(9, 6);
            ctx.lineTo(15, 12);
            ctx.lineTo(9, 18);
            ctx.stroke();
        }
        Connections {
            target: root
            function onTintChanged() { canvas.requestPaint(); }
            function onDirectionChanged() { canvas.requestPaint(); }
            function onWidthChanged() { canvas.requestPaint(); }
            function onHeightChanged() { canvas.requestPaint(); }
        }
    }
}
