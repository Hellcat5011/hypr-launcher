import QtQuick
import QtQuick.Layouts
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    property string timeText: Qt.formatTime(new Date(), "hh:mm")
    property string dateText: Qt.formatDate(new Date(), "ddd, MMM d")
    
    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            var now = new Date()
            timeText = Qt.formatTime(now, "hh:mm")
            dateText = Qt.formatDate(now, "ddd, MMM d")
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 0
        
        // Left zone: Media controls
        Item {
            Layout.preferredWidth: 160
            Layout.fillHeight: true
            
            RowLayout {
                anchors.fill: parent
                spacing: 8
                
                Item {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    visible: typeof MediaService !== "undefined" && (MediaService.isPlaying || MediaService.player)
                    
                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.radiusSmall
                        color: Theme.surfaceVariant
                        clip: true
                        
                        Image {
                            anchors.fill: parent
                            source: typeof MediaService !== "undefined" && MediaService.trackArtUrl ? MediaService.trackArtUrl : ""
                            fillMode: Image.PreserveAspectCrop
                            visible: source.toString() !== ""
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    
                    Text {
                        Layout.fillWidth: true
                        text: (typeof MediaService !== "undefined" && (MediaService.isPlaying || MediaService.player)) ? (MediaService.trackTitle || "Unknown Track") : "No media"
                        color: Theme.pillForeground
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 2
                        visible: typeof MediaService !== "undefined" && (MediaService.isPlaying || MediaService.player)
                        
                        MouseArea {
                            Layout.preferredWidth: 24; Layout.preferredHeight: 24; z: 10
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (typeof MediaService !== "undefined") MediaService.previous()
                            Icons.SkipPrevIcon { anchors.centerIn: parent }
                        }
                        MouseArea {
                            Layout.preferredWidth: 24; Layout.preferredHeight: 24; z: 10
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (typeof MediaService !== "undefined") MediaService.togglePlayPause()
                            Loader {
                                anchors.centerIn: parent
                                sourceComponent: (typeof MediaService !== "undefined" && MediaService.isPlaying) ? pauseIconComponent : playIconComponent
                            }
                        }
                        MouseArea {
                            Layout.preferredWidth: 24; Layout.preferredHeight: 24; z: 10
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (typeof MediaService !== "undefined") MediaService.next()
                            Icons.SkipNextIcon { anchors.centerIn: parent }
                        }
                        // EqBars moved to Clock zone
                    }
                }
            }
        }
        
        // Center zone: Clock
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            RowLayout {
                anchors.centerIn: parent
                spacing: 12
                
                Icons.EqBars {
                    visible: typeof MediaService !== "undefined" && MediaService.isPlaying
                    Layout.preferredWidth: 20; Layout.preferredHeight: 20
                    active: typeof MediaService !== "undefined" && MediaService.isPlaying
                }
                
                Text {
                    text: timeText
                    color: Theme.pillForeground
                    font.family: Theme.fontFamily
                    font.pixelSize: 22
                    font.bold: true
                }
            }
        }
        
        // Right zone: Date
        Item {
            Layout.preferredWidth: 160
            Layout.fillHeight: true
            
            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: dateText
                color: Theme.pillSubtext
                font.family: Theme.fontFamily
                font.pixelSize: 14
                font.bold: true
            }
        }
    }
    
    Component {
        id: playIconComponent
        Icons.PlayIcon { }
    }
    Component {
        id: pauseIconComponent
        Icons.PauseIcon { }
    }
}
