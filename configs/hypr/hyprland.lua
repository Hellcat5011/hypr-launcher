-- NVIDIA ENVIRONMENT VARIABLES (RTX 3060 on Wayland)
hl.config({
    env = {
        "LIBVA_DRIVER_NAME,nvidia",
        "XDG_SESSION_TYPE,wayland",
        "GBM_BACKEND,nvidia-drm",
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    }
})

-- Import submodules
require("user.monitors")
require("user.startup")
require("user.input")
require("user.decorations")
require("user.animations")
require("user.wrules")
require("user.keybinds")
require("user.layouts")
require("user.colors")
require("user.permissions")

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})


