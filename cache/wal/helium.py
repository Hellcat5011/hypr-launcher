#!/usr/bin/env python3
import json
import os

# Paths
cache_path = os.path.expanduser('~/.cache/wal/colors.json')
output_dir = os.path.expanduser('~/.cache/wal/helium-theme')
manifest_file = os.path.join(output_dir, 'manifest.json')

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

def hex_to_rgb(hex_str, default=[0, 0, 0]):
    if not hex_str or not isinstance(hex_str, str):
        return default
    hex_str = hex_str.lstrip('#')
    try:
        # Support both 3-char and 6-char hex
        if len(hex_str) == 3:
            hex_str = ''.join([c*2 for c in hex_str])
        return [int(hex_str[i:i+2], 16) for i in (0, 2, 4)]
    except (ValueError, IndexError):
        return default

# Check if pywal cache exists
if not os.path.exists(cache_path):
    print(f"❌ Error: {cache_path} not found. Run pywal/noctalia first.")
    exit(1)

with open(cache_path, 'r') as f:
    data = json.load(f)

colors = data.get('colors', {})
# Attempt to get special colors if they exist, otherwise fallback
special = data.get('special', {})
bg_rgb = hex_to_rgb(special.get('background', colors.get('color0')), [0, 0, 0])
fg_rgb = hex_to_rgb(special.get('foreground', colors.get('color15')), [255, 255, 255])

c = {}
for i in range(16):
    key = f'color{i}'
    # Use the color, or fallback to background if missing/empty
    val = colors.get(key)
    c[key] = hex_to_rgb(val if val else None, bg_rgb)

manifest = {
    "manifest_version": 3,
    "version": "1.1",
    "name": "Helium Noctalia Theme",
    "theme": {
        "colors": {
            "frame": bg_rgb,
            "toolbar": bg_rgb,
            "ntp_text": fg_rgb,
            "ntp_background": bg_rgb,
            "tab_text": fg_rgb,
            "tab_background_text": c['color8'],
            "bookmark_text": fg_rgb
        }
    }
}

with open(manifest_file, 'w') as f:
    json.dump(manifest, f, indent=4)

print(f"✅ Success! Theme generated at {output_dir}")
print("👉 To apply: Open Helium -> Extensions -> Load Unpacked -> Select the folder.")
