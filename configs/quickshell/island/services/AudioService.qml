pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire

QtObject {
    id: root

    // Track the default audio sink
    property var _sinkTracker: PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Expose volume and mute state
    property real volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0.0
    property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false

    // Signal emitted to show OSD
    signal volumeOsdRequested(real value)

    // Method to set volume
    function setVolume(v) {
        if (Pipewire.defaultAudioSink?.audio) {
            Pipewire.defaultAudioSink.audio.volume = Math.max(0.0, Math.min(1.0, v));
        }
    }

    // Method to toggle mute
    function toggleMute() {
        if (Pipewire.defaultAudioSink?.audio) {
            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
        }
    }

    // Watch for volume changes to trigger the OSD
    onVolumeChanged: {
        volumeOsdRequested(volume);
    }
}
