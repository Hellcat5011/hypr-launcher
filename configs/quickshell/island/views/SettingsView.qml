import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../services"
import "../icons" as Icons

Item {
    id: root
    
    signal dismiss()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

            // ── Bluetooth Bar ──────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                radius: Theme.radiusSmall
                color: Theme.surfaceVariant

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var p = Qt.createQmlObject('import Quickshell.Io; Process { command: ["blueman-manager"]; running: true }', root)
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    Icons.BluetoothIcon {
                        width: 24; height: 24
                        tint: BluetoothService.connected ? Theme.primary : Theme.pillSubtext
                    }

                    Text {
                        Layout.fillWidth: true
                        text: BluetoothService.deviceName
                        color: BluetoothService.connected ? Theme.pillForeground : Theme.pillSubtext
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        font.bold: true
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        text: BluetoothService.deviceBattery
                        color: Theme.pillSubtext
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        visible: BluetoothService.deviceBattery !== ""
                    }
                }
            }

            // ── Brightness Slider ──────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Icons.BrightnessIcon {
                    width: 24; height: 24
                    level: BrightnessService.maxBrightness > 0 ? BrightnessService.brightness / BrightnessService.maxBrightness : 0
                }

                Item {
                    Layout.fillWidth: true
                    height: 24

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 6
                        radius: 3
                        color: Theme.surfaceVariant

                        Rectangle {
                            width: BrightnessService.maxBrightness > 0 ? (BrightnessService.brightness / BrightnessService.maxBrightness) * parent.width : 0
                            height: parent.height
                            radius: 3
                            color: Theme.primary
                        }
                    }

                    Rectangle {
                        width: 16; height: 16
                        radius: 8
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                        x: (BrightnessService.maxBrightness > 0 ? (BrightnessService.brightness / BrightnessService.maxBrightness) * parent.width : 0) - 8
                    }

                    MouseArea {
                        anchors.fill: parent
                        drag.target: Item {} // dummy
                        onPositionChanged: (mouse) => {
                            var ratio = Math.max(0, Math.min(1, mouse.x / width))
                            BrightnessService.setBrightness(Math.round(ratio * BrightnessService.maxBrightness))
                        }
                    }
                }
            }

            // ── Audio Slider ───────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Icons.SpeakerIcon {
                    width: 24; height: 24
                    level: AudioService.volume
                    muted: AudioService.muted
                }

                Item {
                    Layout.fillWidth: true
                    height: 24

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 6
                        radius: 3
                        color: Theme.surfaceVariant

                        Rectangle {
                            width: AudioService.volume * parent.width
                            height: parent.height
                            radius: 3
                            color: Theme.primary
                        }
                    }

                    Rectangle {
                        width: 16; height: 16
                        radius: 8
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                        x: (AudioService.volume * parent.width) - 8
                    }

                    MouseArea {
                        anchors.fill: parent
                        drag.target: Item {} // dummy
                        onPositionChanged: (mouse) => {
                            var ratio = Math.max(0, Math.min(1, mouse.x / width))
                            AudioService.setVolume(ratio)
                        }
                    }
                }

                // Down arrow for output selection
                Icons.ChevronIcon {
                    width: 16; height: 16
                    direction: 'down'
                    tint: Theme.pillSubtext
                    
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8 // Fatter click area
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            // Expand audio selection logic goes here later
                        }
                    }
                }
            }

            // ── Notification Center ────────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            Layout.fillWidth: true
                            text: "Notifications"
                            color: Theme.pillForeground
                            font.family: Theme.fontFamily
                            font.pixelSize: 16
                            font.bold: true
                        }
                        
                        Rectangle {
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 28
                            radius: Theme.radiusSmall
                            color: Theme.surfaceVariant
                            visible: NotifService.history.length > 0
                            
                            Text {
                                anchors.centerIn: parent
                                text: "Clear All"
                                color: Theme.pillForeground
                                font.family: Theme.fontFamily
                                font.pixelSize: 12
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: NotifService.history = []
                            }
                        }
                    }
                    
                    Text {
                        text: "No new notifications"
                        color: Theme.pillSubtext
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        visible: NotifService.history.length === 0
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 40
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: NotifService.history
                        clip: true
                        spacing: 8
                        
                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 72
                            radius: Theme.radiusSmall
                            color: Theme.surfaceVariant
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData.sourceObj) {
                                        try { modelData.sourceObj.invokeDefaultAction() } catch(e) {}
                                    }
                                }
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12
                                
                                Item {
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                    
                                    IconImage {
                                        id: appIcon
                                        anchors.fill: parent
                                        source: Quickshell.iconPath(modelData.icon || "")
                                        visible: source.toString() !== ""
                                    }
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 16
                                        color: Theme.primaryContainer
                                        visible: appIcon.source.toString() === ""
                                        Text {
                                            anchors.centerIn: parent
                                            text: (modelData.appName || "N").charAt(0).toUpperCase()
                                            color: Theme.pillForeground
                                            font.family: Theme.fontFamily
                                            font.bold: true
                                        }
                                    }
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.summary || ""
                                            color: Theme.pillForeground
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 14
                                            font.bold: true
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: modelData.appName || ""
                                            color: Theme.pillSubtext
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 10
                                        }
                                    }
                                    
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.body || ""
                                        color: Theme.pillSubtext
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                        maximumLineCount: 1
                                    }
                                }
                                
                                MouseArea {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    cursorShape: Qt.PointingHandCursor
                                    
                                    Icons.CloseIcon {
                                        anchors.centerIn: parent
                                        width: 16; height: 16
                                    }
                                    
                                    onClicked: {
                                        if (modelData.sourceObj) {
                                            try { modelData.sourceObj.close() } catch(e) {}
                                            try { modelData.sourceObj.dismiss() } catch(e) {}
                                        }
                                        // Remove from history
                                        var newHistory = NotifService.history.slice();
                                        newHistory.splice(index, 1);
                                        NotifService.history = newHistory;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    
    Keys.onEscapePressed: root.dismiss()
    Component.onCompleted: forceActiveFocus()
}
