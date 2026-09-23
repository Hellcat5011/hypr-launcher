// ─────────────────────────────────────────────────────────────────────────
// shell.qml — Dynamic Island entry point
//
// Run with:   qs -c island
// IPC:        qs -c island ipc call island <method>
//
// This file lives at ~/.config/quickshell/island/shell.qml
// ─────────────────────────────────────────────────────────────────────────
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland._GlobalShortcuts
import QtQml
import "services"

ShellRoot {
    id: root

    IslandWindow {
        id: islandWindow
    }
    
    // Force singleton instantiation on startup
    Component.onCompleted: {
        var _n = NotifService.peaceMode;
        var _p = PolkitService.isAuthPending;
        var _c = ClipboardService.entries;
        // Force DesktopEntries to scan immediately so the launcher is pre-populated
        var _d = DesktopEntries.applications.values;
    }
    
    // ── IPC handlers ─────────────────────────────────────────────────────
    // Control from terminal or Hyprland keybinds:
    //   qs -c island ipc call island toggle
    //   qs -c island ipc call island launcher
    //   qs -c island ipc call island settings
    //   qs -c island ipc call island wallpaper
    //   qs -c island ipc call island power
    //   qs -c island ipc call island clipboard
    //   qs -c island ipc call island dismiss
    IpcHandler {
        target: "island"
        function toggle():    void { islandWindow.pill.toggleHover() }
        function launcher():  void { islandWindow.pill.requestState("launcher") }
        function settings():  void { islandWindow.pill.requestState("settings") }
        function wallpaper(): void { islandWindow.pill.requestState("wallpaper") }
        function power():     void { islandWindow.pill.requestState("power") }
        function clipboard(): void { islandWindow.pill.requestState("clipboard") }
        function dismiss():   void { islandWindow.pill.requestState("idle") }
        function brightnessUp(): void { BrightnessService.stepBrightness(5) }
        function brightnessDown(): void { BrightnessService.stepBrightness(-5) }
    }

    IpcHandler {
        target: "theme"
        function reload(): void {
            Theme.forceReload()
        }
    }

    // ── Global Shortcuts (Hyprland global_shortcuts_v1 protocol) ────────
    // These register directly with the compositor — no separate keybind
    // config needed, though hypr/island-binds.conf provides an IPC fallback.
    GlobalShortcut {
        appid: "island"
        name: "launcher"
        description: "Toggle app launcher"
        onPressed: islandWindow.pill.requestState(
            islandWindow.pill.state === "launcher" ? "idle" : "launcher"
        )
    }

    GlobalShortcut {
        appid: "island"
        name: "settings"
        description: "Toggle control center"
        onPressed: islandWindow.pill.requestState(
            islandWindow.pill.state === "settings" ? "idle" : "settings"
        )
    }

    GlobalShortcut {
        appid: "island"
        name: "wallpaper"
        description: "Toggle wallpaper selector"
        onPressed: islandWindow.pill.requestState(
            islandWindow.pill.state === "wallpaper" ? "idle" : "wallpaper"
        )
    }

    GlobalShortcut {
        appid: "island"
        name: "power"
        description: "Toggle power menu"
        onPressed: islandWindow.pill.requestState(
            islandWindow.pill.state === "power" ? "idle" : "power"
        )
    }

    GlobalShortcut {
        appid: "island"
        name: "clipboard"
        description: "Toggle clipboard history"
        onPressed: islandWindow.pill.requestState(
            islandWindow.pill.state === "clipboard" ? "idle" : "clipboard"
        )
    }
}
