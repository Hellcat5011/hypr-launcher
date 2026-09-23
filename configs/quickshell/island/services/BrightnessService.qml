pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property int brightness: 0
    property int maxBrightness: 100

    signal brightnessOsdRequested(real value)

    Process {
        id: readProcess
        command: ["ddcutil", "getvcp", "10", "--brief"]
        
        stdout: SplitParser {
            onRead: data => {
                var parts = data.split(" ");
                if (parts.length >= 5 && parts[0] === "VCP" && parts[1] === "10" && parts[2] === "C") {
                    root.brightness = parseInt(parts[3]);
                    root.maxBrightness = parseInt(parts[4]);
                }
            }
        }
    }

    Process {
        id: writeProcess
        // command set dynamically
    }

    function setBrightness(value) {
        var clamped = Math.max(0, Math.min(maxBrightness, value));
        root.brightness = clamped;
        root.brightnessOsdRequested(clamped / maxBrightness);
        
        writeProcess.command = ["ddcutil", "setvcp", "10", clamped.toString()];
        writeProcess.running = true;
    }

    function stepBrightness(amount) {
        setBrightness(root.brightness + amount);
    }

    Component.onCompleted: {
        readProcess.running = true;
    }
}
