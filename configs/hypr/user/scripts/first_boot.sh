#!/bin/bash

LOCK_FILE="$HOME/.config/hypr/user/scripts/.first_boot_done"

if [ ! -f "$LOCK_FILE" ]; then
	sleep 2

	awww img $HOME/.wa.jpg
	gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
	gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
	gsettings set org.gnome.desktop.interface icon-theme "Slot-gray-Dark-Icons"

	hyprctl set-cursor "Moga-grey" "24"

	matugen image $HOME/.wa.jpg -m dark -t scheme-smart --source-color-index 0

	touch $LOCK_FILE

fi

