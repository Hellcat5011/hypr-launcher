import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    signal switchToClipboard()
    signal dismiss()
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 12
        
        // Search field
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            radius: Theme.radiusSmall
            color: Theme.surfaceVariant
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8
                
                // Canvas search icon placeholder
                Item {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.strokeStyle = Theme.pillForeground
                            ctx.lineWidth = 2
                            ctx.beginPath()
                            ctx.arc(9, 9, 6, 0, Math.PI * 2)
                            ctx.moveTo(13, 13)
                            ctx.lineTo(18, 18)
                            ctx.stroke()
                        }
                    }
                }
                
                TextInput {
                    id: searchInput
                    Layout.fillWidth: true
                    color: Theme.pillForeground
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                    
                    Text {
                        anchors.fill: parent
                        text: "Search apps…"
                        color: Theme.pillSubtext
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        visible: !searchInput.text
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onTextChanged: {
                        updateFilter()
                    }
                    
                    Keys.onEscapePressed: root.dismiss()
                    Keys.onDownPressed: appList.incrementCurrentIndex()
                    Keys.onUpPressed: appList.decrementCurrentIndex()
                    Keys.onReturnPressed: {
                        if (appList.currentItem && appList.model.count > 0) {
                            appList.model.get(appList.currentIndex).entry.execute()
                            root.dismiss()
                        }
                    }
                    
                    Component.onCompleted: forceActiveFocus()
                }
            }
        }
        
        Text {
            text: appList.model.count + " results"
            color: Theme.pillSubtext
            font.family: Theme.fontFamily
            font.pixelSize: 12
        }
        
        ListView {
            id: appList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            highlightMoveDuration: 0
            highlightMoveVelocity: -1
            
            model: ListModel { id: filteredApps }
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 48
                radius: Theme.radiusSmall
                color: ListView.isCurrentItem ? Theme.selectionBackground : (mouseArea.containsMouse ? Theme.surfaceVariant : "transparent")
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 12
                    
                    IconImage {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        source: Quickshell.iconPath(model.entry.icon)
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            Layout.fillWidth: true
                            text: model.entry.name
                            color: ListView.isCurrentItem ? Theme.selectionForeground : Theme.pillForeground
                            font.family: Theme.fontFamily
                            font.pixelSize: 14
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.fillWidth: true
                            text: model.entry.genericName || ""
                            color: ListView.isCurrentItem ? Theme.selectionForeground : Theme.pillSubtext
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            visible: text !== ""
                        }
                    }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        model.entry.execute()
                        root.dismiss()
                    }
                }
            }
            
            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: Theme.animFast; easing.type: Easing.OutCubic }
            }
        }
    }
    
    function updateFilter() {
        filteredApps.clear()
        var q = searchInput.text.toLowerCase().trim()
        var entries = []
        for (const val of DesktopEntries.applications.values) {
            if (!val.noDisplay) {
                entries.push(val);
            }
        }
        entries.sort(function(a, b) { return a.name.localeCompare(b.name); })

        for (var i = 0; i < entries.length; i++) {
            var e = entries[i]
            if (q === "" || 
                (e.name && e.name.toLowerCase().indexOf(q) !== -1) || 
                (e.genericName && e.genericName.toLowerCase().indexOf(q) !== -1)) {
                filteredApps.append({ entry: e })
            }
        }
        appList.currentIndex = 0
    }
    
    Component.onCompleted: {
        // DesktopEntries may not be populated yet on first boot.
        // Retry after a short delay if we get zero results.
        updateFilter()
        if (filteredApps.count === 0) {
            retryTimer.start()
        }
    }

    Timer {
        id: retryTimer
        interval: 500
        repeat: true
        onTriggered: {
            updateFilter()
            if (filteredApps.count > 0) {
                retryTimer.stop()
            }
        }
    }
}
