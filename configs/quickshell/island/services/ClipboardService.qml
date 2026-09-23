pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property var entries: []

    property var _newEntries: []
    Process {
        id: listProcess
        command: ["cliphist", "list"]
        stdout: SplitParser {
            onRead: data => {
                var line = data;
                if (line !== "") {
                    var splitIdx = line.indexOf("\t");
                    if (splitIdx !== -1) {
                        var id = line.substring(0, splitIdx);
                        var text = line.substring(splitIdx + 1);
                        root._newEntries.push({id: id, text: text});
                    }
                }
            }
        }
        onRunningChanged: {
            if (running) {
                root._newEntries = [];
            } else {
                root.entries = root._newEntries;
            }
        }
    }

    Process {
        id: pasteProcess
    }

    function refresh() {
        listProcess.running = true;
    }

    function paste(entry) {
        pasteProcess.command = ["bash", "-c", "cliphist decode <<< '" + entry.id + "' | wl-copy"];
        pasteProcess.running = true;
    }
}
