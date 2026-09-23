import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    signal dismiss()
    
    property string currentWallpaper: ""
    property bool applying: false
    
    // Read current wallpaper
    property string _currentWpBuffer: ""
    Process {
        id: readCurrentWp
        command: ["cat", Quickshell.shellDir + "/data/current-wallpaper.txt"]
        stdout: SplitParser {
            onRead: data => {
                root._currentWpBuffer += data
            }
        }
        onRunningChanged: {
            if (!running && exitCode === 0 && root._currentWpBuffer.trim()) {
                root.currentWallpaper = root._currentWpBuffer.trim()
            }
        }
        Component.onCompleted: running = true
    }
    
    // Find wallpapers
    Process {
        id: findWallpapers
        command: ["find", "/mnt/hdd/Wallpapers/walls", "-type", "f", "-name", "*.jpg", "-o", "-name", "*.png", "-o", "-name", "*.jpeg"]
        stdout: SplitParser {
            onRead: data => {
                var line = data.trim();
                if (line) {
                    wpModel.append({ path: line })
                }
            }
        }
        Component.onCompleted: running = true
    }
    
    Process {
        id: setWallpaperProc
        property string wpPath: ""
        onExited: {
            root.applying = false
            root.currentWallpaper = wpPath
            Theme.forceReload()
            root.dismiss()
        }
    }
    
    PathView {
        id: view
        anchors.fill: parent
        model: ListModel { id: wpModel }
        pathItemCount: 3
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        clip: true
        
        path: Path {
            startX: -view.width * 0.1; startY: view.height / 2
            PathLine { x: view.width * 1.1; y: view.height / 2 }
        }
        
        delegate: Item {
            width: 525
            height: 295.3125
            scale: PathView.isCurrentItem ? 1.0 : 0.75
            opacity: PathView.isCurrentItem ? 1.0 : 0.6
            z: PathView.isCurrentItem ? 10 : 0
            
            Behavior on scale { NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic } }
            
            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
                radius: Theme.radiusSmall
                color: Theme.surfaceVariant
                border.color: PathView.isCurrentItem ? Theme.primary : "transparent"
                border.width: PathView.isCurrentItem ? 3 : 0
                
                ClippingRectangle {
                    anchors.fill: parent
                    anchors.margins: parent.border.width
                    radius: Theme.radiusSmall - parent.border.width
                    
                    Image {
                        anchors.fill: parent
                        source: "file://" + model.path
                        asynchronous: true
                        fillMode: Image.PreserveAspectCrop
                    }
                    
                    Rectangle {
                        anchors.fill: parent
                        color: "#80000000"
                        visible: root.applying && setWallpaperProc.wpPath === model.path
                        
                        Text {
                            anchors.centerIn: parent
                            text: "Applying…"
                            color: "white"
                            font.family: Theme.fontFamily
                            font.bold: true
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (view.currentIndex !== index) {
                            view.currentIndex = index
                        } else if (!root.applying) {
                            root.applying = true
                            setWallpaperProc.wpPath = model.path
                            setWallpaperProc.command = ["sh", "/home/vic/.config/quickshell/quickshell-launcher/scripts/set-wallpaper.sh", model.path]
                            setWallpaperProc.running = true
                        }
                    }
                }
            }
        }
        
        Keys.onLeftPressed: decrementCurrentIndex()
        Keys.onRightPressed: incrementCurrentIndex()
        Keys.onReturnPressed: {
            if (!root.applying && wpModel.count > 0) {
                var modelPath = wpModel.get(currentIndex).path
                root.applying = true
                setWallpaperProc.wpPath = modelPath
                setWallpaperProc.command = ["sh", "/home/vic/.config/quickshell/quickshell-launcher/scripts/set-wallpaper.sh", modelPath]
                setWallpaperProc.running = true
            }
        }
        Keys.onEscapePressed: root.dismiss()
        Component.onCompleted: forceActiveFocus()
    }
}
