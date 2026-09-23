import QtQuick
import QtQuick.Layouts
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    signal switchToLauncher()
    signal dismiss()
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 12
        
        // Search field with prefix
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            radius: Theme.radiusSmall
            color: Theme.surfaceVariant
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8
                
                Text {
                    text: ":"
                    color: Theme.primary
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                }
                
                TextInput {
                    id: searchInput
                    Layout.fillWidth: true
                    color: Theme.pillForeground
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                    
                    Text {
                        anchors.fill: parent
                        text: "clipboard search…"
                        color: Theme.pillSubtext
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        visible: !searchInput.text
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    Keys.onEscapePressed: root.dismiss()
                    Keys.onDownPressed: clipList.incrementCurrentIndex()
                    Keys.onUpPressed: clipList.decrementCurrentIndex()
                    Keys.onReturnPressed: {
                        if (clipList.currentItem && clipList.model.count > 0) {
                            if (typeof ClipboardService !== "undefined") {
                                ClipboardService.paste(clipList.model.get(clipList.currentIndex).entry)
                            }
                            root.dismiss()
                        }
                    }
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Backspace && text === "") {
                            root.switchToLauncher()
                            event.accepted = true
                        }
                    }
                    
                    Component.onCompleted: forceActiveFocus()
                }
            }
        }
        
        ListView {
            id: clipList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            
            // Assuming ClipboardService exposes entries model
            model: typeof ClipboardService !== "undefined" ? ClipboardService.entries : null
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 36
                radius: Theme.radiusSmall
                color: ListView.isCurrentItem ? Theme.selectionBackground : (mouseArea.containsMouse ? Theme.surfaceVariant : "transparent")
                
                Text {
                    anchors.fill: parent
                    anchors.margins: 8
                    text: modelData.text || "" // Access via modelData for JS array
                    color: ListView.isCurrentItem ? Theme.selectionForeground : Theme.pillForeground
                    font.family: Theme.fontFamily
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    
                    Component.onCompleted: {
                        if (text.length > 80) text = text.substring(0, 80) + "..."
                    }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (typeof ClipboardService !== "undefined") {
                            ClipboardService.paste(modelData)
                        }
                        root.dismiss()
                    }
                }
            }
        }
    }
    
    Component.onCompleted: {
        if (typeof ClipboardService !== "undefined") {
            ClipboardService.refresh()
        }
    }
}
