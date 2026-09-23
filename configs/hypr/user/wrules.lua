local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule {
	name = "calculator",
	match = { class = "^(org.gnome.[cC]alculator)$" },

	float = true,
	size = { 360, 616 },
}

hl.window_rule {
	name = "opaque",
	match = { class = "^(mpv|org.gnome.Loupe)$" },

	opaque = true,
}

hl.window_rule {
	name = "xdman",
	match = { class = "^xdman-main$" },

	opacity = 0.8,
}


-- LAYER RULES --

hl.layer_rule {
	name = "wl-eww",
	match = { namespace = "^(mpris|clock|calendar|systray|logout_dialog)$" },

	blur = true,
	blur_popups = true,
}

hl.layer_rule {
	name = "quickshell",
	match = { namespace = "^island$" },

	blur = true,
	ignore_alpha = 0.5,
}

hl.layer_rule {
	name = "quickshell-launcher",
	match = { namespace = "^quickshell$" },

	blur = true,
	-- ignore_alpha = 0.5,
	dim_around = true,
}

hl.layer_rule {
	name = "notif",
	match = { namespace = "^osd$" },

	blur = true,
	ignore_alpha = 0.5,
}

hl.layer_rule {
	name = "wallpaper",
	match = { namespace = "^wallpaper$" },

	blur = true,
	ignore_alpha = 0.5,
}

hl.layer_rule {
	name = "power",
	match = { namespace = "^power$" },

	blur = true,
	dim_around = true,
}

hl.layer_rule {
	name = "desktop",
	match = { namespace = "^desktop$" },

	blur = true,
	ignore_alpha = 0.1,
	blur_popups = true,
}

