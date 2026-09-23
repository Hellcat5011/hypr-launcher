hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 2,

        border_size = 2,

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "scrolling",
    },

    layout = {
    	single_window_aspect_ratio = "4 3",
},
    cursor = {
	    no_warps = true,
    },

    decoration = {
        rounding       = 2,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.9,
        inactive_opacity = 0.7,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 4,
            passes    = 2,

	    brightness = 0.9,
	    contrast	= 1.5,

	    --variant   = ripple,
            vibrancy  = 0.1696,
	    vibrancy_darkness = 0.2,
        },
    },

    animations = {
        enabled = true,
    },
})


