pragma Singleton
// ─────────────────────────────────────────────────────────────────────────
// Theme.qml — Matugen Material You palette + motion/shape tokens
//
// Reads the same matugen-generated colors.json palette used by
// quickshell-launcher. A second matugen template entry outputs to
// this project's data/colors.json.
//
// All color, animation, and layout constants live here so the entire
// island can be re-themed from a single file.
// ─────────────────────────────────────────────────────────────────────────
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    // ── Paths ────────────────────────────────────────────────────────────
    readonly property string colorsPath: "/home/vic/.config/quickshell/quickshell-launcher/data/colors.json"

    // ── Font ─────────────────────────────────────────────────────────────
    readonly property string fontFamily: "CaskaydiaCove Nerd Font Mono"

    // ── Color reader ─────────────────────────────────────────────────────
    property Process colorReader: Process {
        id: colorReader
        command: ["cat", root.colorsPath]

        property string jsonContent: ""

        onRunningChanged: {
            if (running) {
                jsonContent = ""
            } else if (jsonContent.trim().length > 0) {
                try {
                    root._apply(JSON.parse(jsonContent))
                } catch (e) {
                    console.warn("Theme: could not parse colors.json —", e)
                }
            }
        }

        stdout: SplitParser {
            onRead: data => {
                colorReader.jsonContent += data + "\n"
            }
        }
    }

    function forceReload() {
        colorReader.running = true
    }

    Component.onCompleted: {
        forceReload()
    }

    function _apply(c) {
        background         = c.background          ?? background
        backgroundText     = c.on_background        ?? backgroundText
        surface            = c.surface              ?? surface
        surfaceVariant     = c.secondary_container  ?? surfaceVariant
        surfaceText        = c.on_surface           ?? surfaceText
        surfaceVariantText = c.on_surface_variant   ?? surfaceVariantText
        primary            = c.primary              ?? primary
        primaryText        = c.on_primary           ?? primaryText
        primaryContainer   = c.primary_container    ?? primaryContainer
        secondary          = c.secondary            ?? secondary
        secondaryContainer = c.secondary_container  ?? secondaryContainer
        outline            = c.outline              ?? outline
        outlineVariant     = c.outline_variant      ?? outlineVariant
        error              = c.error                ?? error
        shadow             = c.shadow               ?? shadow
        inverseSurface     = c.inverse_surface      ?? inverseSurface
        inverseSurfaceText = c.inverse_on_surface   ?? inverseSurfaceText
        inversePrimary     = c.inverse_primary      ?? inversePrimary
        primaryContainerText = c.on_primary_container ?? primaryContainerText
    }

    // ── Matugen Material You palette ─────────────────────────────────────
    // Fallback: magenta to make missing colors obvious during dev.
    property color background:         "#1a1a2e"
    property color backgroundText:     "#e0e0ec"
    property color surface:            "#1e1e32"
    property color surfaceVariant:     "#2e3a50"
    property color surfaceText:        "#e8e8f0"
    property color surfaceVariantText: "#a0a0b4"
    property color primary:            "#7c9ff0"
    property color primaryText:        "#0a0a1a"
    property color primaryContainer:   "#2a3a5e"
    property color primaryContainerText: "#d0d0ff"
    property color secondary:          "#a0b0d0"
    property color secondaryContainer: "#2e3a50"
    property color outline:            "#4a4a60"
    property color outlineVariant:     "#3a3a50"
    property color error:              "#f28b82"
    property color shadow:             "#000000"
    property color inverseSurface:     "#e0e0ec"
    property color inverseSurfaceText: "#1a1a2e"
    property color inversePrimary:     "#405080"

    // ── Island-specific derived colors ───────────────────────────────────
    // 1) background color to be inverse-primary (65% opacity)
    readonly property color pillBackground:
        Qt.rgba(inversePrimary.r, inversePrimary.g, inversePrimary.b, 0.65)
    readonly property color pillBorder:
        Qt.rgba(inversePrimary.r, inversePrimary.g, inversePrimary.b, 0.45)
        
    // 2) font and other non-selected entries to be on-primary-container (65% opacity)
    readonly property color pillForeground: 
        Qt.rgba(primaryContainerText.r, primaryContainerText.g, primaryContainerText.b, 0.65)
    readonly property color pillSubtext: 
        Qt.rgba(primaryContainerText.r, primaryContainerText.g, primaryContainerText.b, 0.45) // Slightly less for subtext

    // 3) selection background = on-primary-container, selected font = inverse-primary
    readonly property color selectionBackground:
        Qt.rgba(primaryContainerText.r, primaryContainerText.g, primaryContainerText.b, 0.65)
    readonly property color selectionForeground:
        Qt.rgba(inversePrimary.r, inversePrimary.g, inversePrimary.b, 0.65)

    // Semi-transparent variants for layered surfaces inside the pill.
    // Making these primaryContainerText as requested for "non-selected entries"
    readonly property color surfaceA80:
        Qt.rgba(primaryContainerText.r, primaryContainerText.g, primaryContainerText.b, 0.15)
    readonly property color primaryContainerA80:
        Qt.rgba(primaryContainerText.r, primaryContainerText.g, primaryContainerText.b, 0.25)

    // ── Motion tokens ────────────────────────────────────────────────────
    // Spring parameters: tuned to be 2x faster and more fluidic
    readonly property real springStiffness: 9.0
    readonly property real springDamping:   0.45
    readonly property real springEpsilon:   0.25

    // Duration-based animations (crossfades, opacity transitions).
    readonly property int crossfadeDuration: 75
    readonly property int animFast:          60
    readonly property int animMed:           110
    readonly property int animSlow:          190

    // ── Timing tokens ────────────────────────────────────────────────────
    readonly property int osdTimeout:     1500  // OSD auto-dismiss (ms)
    readonly property int notifTimeout:   4000  // Normal notification (ms)
    readonly property int notifCritical:  8000  // Critical notification (ms)
    readonly property int notifLow:       2500  // Low-urgency notification (ms)

    // ── Shape tokens ─────────────────────────────────────────────────────
    readonly property int radiusSmall: 12
    readonly property int radiusLarge: 24
    readonly property int pillRadius:  999   // Fully rounded (clamped by height/2)
}
