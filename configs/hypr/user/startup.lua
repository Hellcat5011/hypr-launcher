hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor Moga-Grey 24")
	hl.exec_cmd("env QT_IMAGEIO_MAXALLOC=0 qs -c quickshell-launcher")
	hl.exec_cmd("awww-daemon & hypridle")
	hl.exec_cmd("nm-applet --indicator & blueman-applet & kdeconnectd & kdeconnect-indicator")
	hl.exec_cmd("mpd-mpris -host 127.0.0.1 -port 6600")

	hl.exec_cmd("awww img /home/vic/.wa.jpg")
	-- hl.exec_cmd("eww open-many mpris clock calendar systray")
	hl.exec_cmd("wlsunset -S 07:00 -s 17:00 -d 600")

	hl.exec_cmd("sh -c '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome/polkit-gnome-authentication-agent-1'")
	hl.exec_cmd("sleep 2 && dex -a -s ~/.config/autostart/")

	-- hl.exec_cmd("wl-paste --type text --watch cliphist store")
	-- hl.exec_cmd("wl-paste --type image --watch cliphist store")
	-- hl.exec_cmd("wl-paste -p --type text --watch cliphist store")

end)
