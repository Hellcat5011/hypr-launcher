pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root
    
    property string deviceName: "Not Connected"
    property string deviceBattery: ""
    property bool connected: false

    property string _buffer: ""

    Process {
        id: btProc
        command: ["bash", "-c", "info=$(bluetoothctl info 2>/dev/null); if echo \"$info\" | grep -q 'Connected: yes'; then name=$(echo \"$info\" | awk -F': ' '/Alias:/ {print $2}'); batt=$(echo \"$info\" | grep -o 'Battery Percentage:.*' | grep -oE '\\([0-9]+\\)' | tr -d '()'); echo \"$name|$batt\"; else echo 'Not Connected|'; fi"]
        
        stdout: SplitParser {
            onRead: data => {
                root._buffer += data;
            }
        }
        
        onRunningChanged: {
            if (!running) {
                if (root._buffer) {
                    var parts = root._buffer.trim().split("|")
                    root.deviceName = parts[0] || "Not Connected"
                    if (root.deviceName !== "Not Connected" && parts.length > 1 && parts[1]) {
                        root.deviceBattery = parts[1] + "%"
                        root.connected = true
                    } else {
                        root.deviceBattery = ""
                        root.connected = root.deviceName !== "Not Connected"
                    }
                }
                root._buffer = ""
            }
        }
    }
    
    Timer {
        interval: 10000
        repeat: true
        running: true
        onTriggered: {
            btProc.running = true
        }
    }
    
    Component.onCompleted: btProc.running = true
}
