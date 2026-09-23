import QtQuick
import QtQuick.Layouts
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    property string osdType: "volume"
    property real osdValue: 0.0
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 16
        
        Loader {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            sourceComponent: osdType === "volume" ? volumeIcon : brightnessIcon
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            radius: 2
            color: Theme.surfaceVariant
            
            Rectangle {
                width: parent.width * osdValue
                height: parent.height
                radius: 2
                color: Theme.primary
                
                Behavior on width {
                    NumberAnimation {
                        duration: Theme.crossfadeDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
        
        Text {
            Layout.preferredWidth: 40
            text: Math.round(osdValue * 100) + "%"
            color: Theme.pillForeground
            font.family: Theme.fontFamily
            font.pixelSize: 14
            horizontalAlignment: Text.AlignRight
        }
    }
    
    Component {
        id: volumeIcon
        Icons.SpeakerIcon {
            level: osdValue
            muted: typeof AudioService !== "undefined" && AudioService.muted
        }
    }
    
    Component {
        id: brightnessIcon
        Icons.BrightnessIcon {
            level: osdValue
        }
    }
}
