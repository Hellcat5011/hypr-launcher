// ─────────────────────────────────────────────────────────────────────────
// IslandPill.qml — the hero morphing element
//
// A single Rectangle that changes size, radius, and internal content based
// on its `state` property. Every geometric change runs through critically
// damped spring animations for fluid, zero-wobble motion.
//
// States:
//   idle         → compact clock pill (default resting state)
//   hover        → expanded 3-zone status bar (media | clock | status)
//   osd          → compact volume/brightness level meter
//   notification → alert banner with app icon + text
//   launcher     → search bar + results list
//   clipboard    → clipboard history list
//   wallpaper    → wallpaper thumbnail grid
//   settings     → configuration sliders panel
//   power        → action tiles row
//   polkit       → authentication prompt card
//
// Content switching: each state loads its view via a Loader with opacity
// crossfade. Only the active view is loaded; others are destroyed.
// ─────────────────────────────────────────────────────────────────────────
import QtQuick
import QtQuick.Effects
import "services"
import "views" as Views
import "icons" as Icons

Rectangle {
    id: pill

    // ── Public API ───────────────────────────────────────────────────────
    // External controllers (shell.qml IPC, services) call these to drive
    // the island.

    // Request a state transition. If already in that state, return to idle.
    function requestState(newState) {
        if (pill.state === newState) {
            pill.state = "idle"
        } else {
            _pinned = false
            pill.state = newState
        }
        _restartAutoDismiss()
    }

    // Toggle between idle and hover.
    function toggleHover() {
        if (pill.state === "idle") {
            pill.state = "hover"
        } else {
            pill.state = "idle"
        }
    }

    // Called by OSD service signals (volume/brightness changed).
    function showOsd(type, value) {
        _osdType = type    // "volume" or "brightness"
        _osdValue = value  // 0.0 – 1.0
        pill.state = "osd"
        _restartAutoDismiss()
    }

    // Called by notification service when a new notification arrives.
    function showNotification(notification) {
        _currentNotification = notification
        pill.state = "notification"
        _restartAutoDismiss()
    }

    // Called by polkit service when authentication is requested.
    function showPolkit() {
        pill.state = "polkit"
    }

    // ── Internal state ───────────────────────────────────────────────────
    property bool   _pinned: false
    property string _osdType: "volume"
    property real   _osdValue: 0.0
    property var    _currentNotification: null

    function _restartAutoDismiss() {
        autoDismissTimer.restart()
    }

    // ── Visual styling ──────────────────────────────────────────────────
    color: Theme.pillBackground
    border.color: Theme.pillBorder
    border.width: 1
    radius: height / 2  // Fully rounded pill in compact states

    // Subtle drop shadow via layer effect.
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, 0.45)
        shadowVerticalOffset: 3
        shadowHorizontalOffset: 0
        shadowBlur: 0.6
    }

    // ── Default geometry (idle) ─────────────────────────────────────────
    width: 200
    height: 38

    // ── Spring animations on all geometry ───────────────────────────────
    // Critically damped: fast arrival, zero overshoot/wobble.
    // spring ≈ stiffness, damping ≈ 0.88 (critically damped zone).
    Behavior on width {
        SpringAnimation {
            spring: Theme.springStiffness
            damping: Theme.springDamping
            epsilon: Theme.springEpsilon
        }
    }
    Behavior on height {
        SpringAnimation {
            spring: Theme.springStiffness
            damping: Theme.springDamping
            epsilon: Theme.springEpsilon
        }
    }
    Behavior on radius {
        SpringAnimation {
            spring: Theme.springStiffness
            damping: Theme.springDamping
            epsilon: Theme.springEpsilon
        }
    }

    // ── State definitions ───────────────────────────────────────────────
    state: "idle"
    states: [
        State {
            name: "idle"
            PropertyChanges { target: pill; width: 200; height: 38; radius: 19 }
        },
        State {
            name: "hover"
            PropertyChanges { target: pill; width: 640; height: 72; radius: 36 }
        },
        State {
            name: "osd"
            PropertyChanges { target: pill; width: 300; height: 44; radius: 22 }
        },
        State {
            name: "notification"
            PropertyChanges { target: pill; width: 380; height: 80; radius: 24 }
        },
        State {
            name: "launcher"
            PropertyChanges { target: pill; width: 600; height: 525; radius: 24 }
        },
        State {
            name: "clipboard"
            PropertyChanges { target: pill; width: 420; height: 380; radius: 24 }
        },
        State {
            name: "wallpaper"
            PropertyChanges { target: pill; width: 800; height: 320; radius: 24 }
        },
        State {
            name: "settings"
            PropertyChanges { target: pill; width: 400; height: 500; radius: 24 }
        },
        State {
            name: "power"
            PropertyChanges { target: pill; width: 460; height: 120; radius: 28 }
        },
        State {
            name: "polkit"
            PropertyChanges { target: pill; width: 400; height: 240; radius: 24 }
        }
    ]

    // ── Auto-dismiss timer ──────────────────────────────────────────────
    // Transient states (osd, notification) auto-return to idle.
    Timer {
        id: autoDismissTimer
        interval: pill.state === "osd" ? Theme.osdTimeout
                : pill.state === "notification" ? Theme.notifTimeout
                : 0
        repeat: false
        onTriggered: {
            if (pill._pinned) return
            if (pill.state === "osd" || pill.state === "notification") {
                pill.state = "idle"
            }
        }
    }

    // ── Hover interaction ───────────────────────────────────────────────
    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true

        // Hover: expand from idle to hover
        onEntered: {
            if (pill.state === "idle") {
                pill.state = "hover"
            }
            // Pause auto-dismiss for notifications
            if (pill.state === "notification") {
                autoDismissTimer.stop()
            }
        }
        onExited: {
            // Collapse back to idle from hover (unless pinned)
            if (pill.state === "hover" && !pill._pinned) {
                pill.state = "idle"
            }
            // Resume auto-dismiss for notifications
            if (pill.state === "notification" && !pill._pinned) {
                pill._restartAutoDismiss()
            }
        }

        // Click empty space: toggle pinned state.
        // Clicks on action buttons inside views are handled by those views
        // and won't propagate here due to their own MouseAreas.
        onClicked: {
            if (pill.state === "notification") {
                // Click dismisses notification
                if (pill._currentNotification) {
                    pill._currentNotification.dismiss()
                }
                pill.state = "idle"
            } else if (pill.state === "hover") {
                pill._pinned = !pill._pinned
            } else if (pill.state === "idle") {
                pill.state = "hover"
            }
        }
    }

    // ── Content loaders ─────────────────────────────────────────────────
    // Each view fades in/out with a crossfade. Only the active state's
    // Loader sets active: true, which creates the component. Inactive
    // loaders destroy their content to save memory.

    Loader {
        anchors.fill: parent
        active: pill.state === "idle"
        sourceComponent: Views.IdleView {}
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        active: pill.state === "hover"
        sourceComponent: Views.HoverView {}
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        active: pill.state === "osd"
        sourceComponent: Views.OsdView {
            osdType: pill._osdType
            osdValue: pill._osdValue
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        active: pill.state === "notification"
        sourceComponent: Views.NotificationView {
            notification: pill._currentNotification
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        anchors.margins: 12
        active: pill.state === "launcher"
        sourceComponent: Views.LauncherView {
            onSwitchToClipboard: pill.requestState("clipboard")
            onDismiss: pill.requestState("idle")
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        anchors.margins: 12
        active: pill.state === "clipboard"
        sourceComponent: Views.ClipboardView {
            onSwitchToLauncher: pill.requestState("launcher")
            onDismiss: pill.requestState("idle")
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        anchors.margins: 12
        active: pill.state === "wallpaper"
        sourceComponent: Views.WallpaperView {
            onDismiss: pill.requestState("idle")
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }



    Loader {
        anchors.fill: parent
        anchors.margins: 12
        active: pill.state === "settings"
        sourceComponent: Views.SettingsView {
            onDismiss: pill.requestState("idle")
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        active: pill.state === "power"
        sourceComponent: Views.PowerView {
            onDismiss: pill.requestState("idle")
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    Loader {
        anchors.fill: parent
        anchors.margins: 12
        active: pill.state === "polkit"
        sourceComponent: Views.PolkitView {
            onDismiss: pill.requestState("idle")
        }
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Theme.crossfadeDuration; easing.type: Easing.OutCubic } }
    }

    // ── Keyboard handling ───────────────────────────────────────────────
    // Escape always returns to idle from any state.
    Keys.onEscapePressed: {
        pill.state = "idle"
        pill._pinned = false
    }

    // ── Service connections ──────────────────────────────────────────────
    // React to system events by morphing into the appropriate state.

    Connections {
        target: AudioService
        function onVolumeOsdRequested(value) {
            // Don't interrupt higher-priority states
            if (pill.state === "launcher" || pill.state === "polkit" ||
                pill.state === "power") return
            pill.showOsd("volume", value)
        }
    }

    Connections {
        target: BrightnessService
        function onBrightnessOsdRequested(value) {
            if (pill.state === "launcher" || pill.state === "polkit" ||
                pill.state === "power") return
            pill.showOsd("brightness", value)
        }
    }

    Connections {
        target: NotifService
        function onNotificationPosted(notification) {
            if (NotifService.peaceMode) return
            // Don't interrupt polkit or power menu
            if (pill.state === "polkit" || pill.state === "power") return
            pill.showNotification(notification)
        }
    }

    Connections {
        target: PolkitService
        function onAuthRequested() {
            pill.showPolkit()
        }
    }
}
