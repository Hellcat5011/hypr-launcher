import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    property var notification: null
    
    Rectangle {
        id: criticalAccent
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 4
        color: Theme.error
        visible: notification?.urgency === NotificationUrgency.Critical
        radius: Theme.pillRadius
        
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 4
            width: root.width - 4
            color: Theme.error
            opacity: 0.1
            visible: parent.visible
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        Item {
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            
            IconImage {
                id: appIcon
                anchors.fill: parent
                source: Quickshell.iconPath(notification?.icon ?? "")
                visible: source.toString() !== ""
            }
            
            Rectangle {
                anchors.fill: parent
                radius: 18
                color: Theme.primaryContainer
                visible: appIcon.source.toString() === ""
                
                Text {
                    anchors.centerIn: parent
                    text: (notification?.appName ?? "N").charAt(0).toUpperCase()
                    color: Theme.pillForeground
                    font.family: Theme.fontFamily
                    font.bold: true
                }
            }
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            
            Text {
                Layout.fillWidth: true
                text: notification?.summary ?? ""
                color: Theme.pillForeground
                font.family: Theme.fontFamily
                font.pixelSize: 14
                font.bold: true
                elide: Text.ElideRight
            }
            
            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: notification?.body ?? ""
                color: notification?.urgency === NotificationUrgency.Low ? Theme.pillSubtext : Theme.pillForeground
                font.family: Theme.fontFamily
                font.pixelSize: 12
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }
        }
        
        MouseArea {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignTop
            cursorShape: Qt.PointingHandCursor
            
            Icons.CloseIcon {
                anchors.centerIn: parent
                width: 16; height: 16
            }
            
            onClicked: {
                if (notification && notification.sourceObj) {
                    try { notification.sourceObj.close() } catch(e) {}
                    try { notification.sourceObj.dismiss() } catch(e) {}
                }
                if (typeof islandWindow !== "undefined") islandWindow.pill.requestState("idle")
            }
        }
    }
}
