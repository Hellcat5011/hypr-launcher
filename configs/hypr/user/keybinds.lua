local mainMod = "SUPER" -- Sets "Windows" key as main modifier

local terminal = "ghostty"
local fileManager = "nautilus -w"
local browser = "helium-browser"
local menu = "fuzzel"

-- Main keybinds

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + escape", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())


-- CUSTOM KEYBINDS

-- hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu -- prompt 'Clipboard history:' | cliphist decode | wl-copy"))
-- hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("blueman-manager"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("pavucontrol"))
hl.bind("ALT + CTRL + L", hl.dsp.exec_cmd("hyprlock"))


-- quick-launcher

-- hl.bind("ALT + CTRL + DELETE", hl.dsp.exec_cmd("wlogout -b 4"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call notif toggle"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call wallpaper toggle"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call launcher toggle"))
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call power toggle"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call clipboard toggle"))
hl.bind("PRINT", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call screenshot region"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call screenshot window"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("qs -c quickshell-launcher ipc call screenshot output"))

-- dynamic island

-- hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("qs -c island ipc call island wallpaper"))
-- hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("qs -c island ipc call island clipboard"))
-- hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("qs -c island ipc call island launcher"))
-- hl.bind("ALT + CTRL + DELETE", hl.dsp.exec_cmd("qs -c island ipc call island power"))
-- hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("qs -c island ipc call island settings"))
-- hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("qs -c island ipc call island brightnessUp"))
-- hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd("qs -c island ipc call island brightnessDown"))


hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a -n"))

-- hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Pictures/Screenshots"))
-- hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m active -m output -o $HOME/Pictures/Screenshots"))

-- Window navigation

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Window navigation

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.swap({ direction = "down" }))

-- WORKSPACES

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + Next", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + Prior", hl.dsp.focus({ workspace = "-1" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))


-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("/home/vic/.config/hypr/user/scripts/volume.sh +5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("/home/vic/.config/hypr/user/scripts/volume.sh -5"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("/home/vic/.config/hypr/user/scripts/volume.sh mute"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- brightness scripts
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("/home/vic/.config/hypr/user/scripts/brightness.sh + 5")) 
hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd("/home/vic/.config/hypr/user/scripts/brightness.sh - 5")) 



-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


