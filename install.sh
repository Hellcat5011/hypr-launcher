#!/bin/sh

dir = $(pwd)

if ! pacman -Qs yay > /dev/null; then

	. /etc/os-release
	if [ "$ID" = "cachyos" ]; then
		sudo pacman -S --noconfirm yay
	else
		sudo pacman -S --noconfirm git base-devel
		git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
		cd /tmp/yay-bin && makepkg -si --noconfirm
		rm -rf /tmp/yay-bin
	fi
fi

cd $dir

[[ ! -d "$HOME/.config" ]] && mkdir "$HOME/.config"
[[ ! -d "$HOME/.cache" ]] && mkdir "$HOME/.cache"

yay -S --needed --noconfirm $(cat ./progs.txt)

cp -R ./configs/* $HOME/.config/

# Safely replace __USER_HOME__ only in files that contain it to avoid modifying unrelated files
grep -rl "__USER_HOME__" "$HOME/.config" 2>/dev/null | while IFS= read -r file; do
    sed -i "s|__USER_HOME__|$HOME|g" "$file"
done

cp -R ./cache/* $HOME/.cache/

cp -R ./.wa.jpg $HOME/.wa.jpg

chrome="$HOME/.cache/wal/helium-theme"
helium-browser --no-first-run --disable-extensions-except="$chrome" --load-extension="$chrome"

sudo cp ./greetd-config.toml /etc/greetd/config.toml
sudo systemctl enable greetd

systemctl --user enable mpd-mpris

if [ ! -d "$HOME/.local/share/fonts" ]; then
	mkdir -p $HOME/.local/share/fonts
fi

cp -R ./fonts/* $HOME/.local/share/fonts/
fc-cache -fv

echo "You can reboot your system now..."

