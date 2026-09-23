import QtQuick
import QtQuick.Layouts
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    property string timeText: Qt.formatTime(new Date(), "hh:mm")
    
    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: timeText = Qt.formatTime(new Date(), "hh:mm")
    }
    
    RowLayout {
        anchors.centerIn: parent
        spacing: 12
        
        Icons.EqBars {
            visible: typeof MediaService !== "undefined" && MediaService.isPlaying
            active: typeof MediaService !== "undefined" && MediaService.isPlaying
            width: 16
            height: 16
        }
        
        Text {
            text: timeText
            color: Theme.pillForeground
            font.family: Theme.fontFamily
            font.pixelSize: 16
            font.bold: true
            verticalAlignment: Text.AlignVCenter
        }
        

    }
}
