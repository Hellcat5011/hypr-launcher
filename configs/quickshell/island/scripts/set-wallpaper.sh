#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────
# set-wallpaper.sh — sets wallpaper via swww, runs matugen, reloads theme
#
# Usage: set-wallpaper.sh /path/to/wallpaper.jpg
# ─────────────────────────────────────────────────────────────────────────
set -euo pipefail

WALLPAPER="${1:?Usage: set-wallpaper.sh <path>}"
DATA_DIR="$HOME/.config/quickshell/island/data"

# 1. Set the wallpaper with a smooth transition
awww img "$WALLPAPER" \
    --transition-type random \
    --transition-duration 2 \
    --transition-fps 60

# 2. Copy to a stable path for other tools
cp "$WALLPAPER" "$HOME/.wa.jpg"

# 3. Run matugen to regenerate the color palette
matugen image "$WALLPAPER" -m dark -t scheme-smart --source-color-index 0

# 4. Record which wallpaper is active
echo "$WALLPAPER" > "$DATA_DIR/current-wallpaper.txt"

# 5. Reload the theme in both quickshell projects
qs -c island ipc call theme reload 2>/dev/null || true
qs -c quickshell-launcher ipc call theme reload 2>/dev/null || true
