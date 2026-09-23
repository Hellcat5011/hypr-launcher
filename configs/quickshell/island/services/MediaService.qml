pragma Singleton
import QtQuick
import Quickshell.Services.Mpris

QtObject {
    id: root

    property var player: {
        var active = null;
        if (Mpris.players && Mpris.players.values) {
            for (const p of Mpris.players.values) {
                if (p && p.isPlaying) {
                    return p;
                }
                active = p;
            }
        }
        return active;
    }

    // Guarded properties
    property string trackTitle: player?.trackTitle ?? ""
    property string trackArtist: player?.trackArtist ?? ""
    property string trackAlbum: player?.trackAlbum ?? ""
    property string trackArtUrl: player?.trackArtUrl ?? ""
    property bool isPlaying: player?.isPlaying ?? false
    property real position: player?.position ?? 0
    property real length: player?.length ?? 0
    property bool canNext: player?.canGoNext ?? false
    property bool canPrevious: player?.canGoPrevious ?? false

    // Methods
    function play() { _runCmd(["playerctl", "play"]); }
    function pause() { _runCmd(["playerctl", "pause"]); }
    function next() { _runCmd(["playerctl", "next"]); }
    function previous() { _runCmd(["playerctl", "previous"]); }
    function togglePlayPause() { _runCmd(["playerctl", "play-pause"]); }
    
    function _runCmd(cmd) {
        Qt.createQmlObject('import QtQuick; import Quickshell.Io; Process { command: ' + JSON.stringify(cmd) + '; running: true; onRunningChanged: if (!running) destroy() }', root)
    }
}
