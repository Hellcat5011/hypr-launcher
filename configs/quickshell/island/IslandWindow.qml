// ─────────────────────────────────────────────────────────────────────────
// IslandWindow.qml — transparent PanelWindow with click-through mask
//
// The window spans the full screen width, anchored to the top edge.
// It is completely transparent — only the IslandPill inside it is visible.
// The `mask` property ensures clicks outside the pill pass through to
// Hyprland windows underneath, so the island never blocks interaction.
// ─────────────────────────────────────────────────────────────────────────
import QtQuick
import Quickshell
import Quickshell.Wayland
import "services"

PanelWindow {
    id: win

    // Expose the pill so shell.qml's IPC handlers can drive state changes.
    property alias pill: islandPill

    // ── Wayland layer-shell configuration ────────────────────────────────
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "island"
    // No exclusive zone — the island floats over everything without
    // pushing tiled windows down.
    exclusionMode: ExclusionMode.Ignore

    focusable: {
        const s = pill.state;
        return s === "launcher" || s === "clipboard" || s === "wallpaper" || s === "polkit" || s === "power" || s === "settings";
    }

    onFocusableChanged: {
        if (focusable) {
            win.visible = false
            win.visible = true
        }
    }

    color: "transparent"

    // Anchor to all edges to span the full screen. This ensures the background
    // click catcher covers the entire display when focusable is true.
    anchors { top: true; left: true; right: true; bottom: true }

    // ── Input mask ───────────────────────────────────────────────────────
    // A child item representing the full window geometry when focusable
    Item {
        id: bgMask
        anchors.fill: parent
        visible: focusable
    }

    // CRITICAL: Without this, the entire transparent window
    // would swallow every click. The Region tracks geometry each frame, 
    // so only the visible area is interactive.
    mask: Region {
        item: focusable ? bgMask : islandPill
    }
    
    // Background click catcher to dismiss when focusable
    MouseArea {
        anchors.fill: parent
        visible: focusable
        onClicked: {
            if (pill.state !== "idle" && pill.state !== "hover") {
                pill.requestState("idle")
            }
        }
    }

    // ── The island itself ────────────────────────────────────────────────
    IslandPill {
        id: islandPill
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter

        // Pass the parent window reference so views that need keyboard
        // focus (launcher, polkit) can request it from the layer shell.
        property PanelWindow parentWindow: win
    }
}
