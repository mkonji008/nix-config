#!/usr/bin/env bash

red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

read -p "enter username: " user_name

read -p "is '$user_name' the correct username? (y/n): " username_confirm
if [[ $username_confirm != "y" && $username_confirm != "Y" ]]; then
	echo "error: username not confirmed."
	exit 1
fi

if ! id -u "$user_name" &>/dev/null; then
	echo "error: username '$user_name' not found."
	exit 1
fi

home_dir="/home/$user_name"

##
default_dirs=(".config" "Documents" "Downloads" "Music" "Pictures" "Videos" "code" "code/dots" "code/tmp" "code/ext" "/code/prj")

for dir in "${default_dirs[@]}"; do
	if [ ! -d "$home_dir/$dir" ]; then
		echo "creating directory '$home_dir/$dir'..."
		mkdir -p "$home_dir/$dir" || {
			echo "error: failed to create directory '$home_dir/$dir'"
			exit 1
		}
		echo "directory created successfully."
	else
		echo "directory '$home_dir/$dir' already exists, skipping creation."
	fi
done

##
echo "checking current nixos channel..."
current_channel=$(nix-channel --list | grep 'nixos https://nixos.org/channels/nixos-unstable')
if [[ -z "$current_channel" ]]; then
	echo "not currently on nixos unstable channel, updating channels..."
	nix-channel --remove nixos
	nix-channel --add https://nixos.org/channels/nixos-unstable nixos
	nix-channel --update || {
		echo "error: failed to update nixos channels."
		exit 1
	}
	echo "nixos channels updated successfully."
else
	echo "nixos already on unstable channel, skipping update."
fi

##
# inital run if you are getting an error, usually caused by lowmem..
# run once once by doing a $nixos-rebuild switch before the configuration.nix is copied
#
# echo "rebuilding nixos configuration...(run1)"
# nixos-rebuild switch || { echo "error: failed to rebuild nixos configuration.(run1)"; exit 1; }
# echo "nixos configuration rebuilt.(run1)"

##
read -p "copy configuration.nix and hardware-configuration.nix to /etc/nixos/? (y/n) " -r confirm_nix_copy
if [[ "$confirm_nix_copy" =~ ^[yy]$ ]]; then
	echo "copying configuration files..."
	cp -f configuration.nix /etc/nixos/
	#  cp -f hardware-configuration.nix /etc/nixos/
	echo "configuration files copied."

	echo "rebuilding nixos configuration..."
	nixos-rebuild switch || {
		echo "error: failed to rebuild nixos configuration."
		exit 1
	}
	echo "nixos configuration rebuilt."
else
	echo "skipping configuration file copy."
fi

##
bashrc="$home_dir/nix-config/dots/.bashrc"

read -p "setup oh-my-bash? (y/n) " setup_omb

if [ "$setup_omb" != "${setup_omb#[Yy]}" ]; then
	doas -u $user_name bash -c 'bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)" &'
	wait
	if [ $? -eq 0 ]; then
		echo "oh-my-bash installed successfully."
	else
		echo "error: oh-my-bash installation failed."
		exit 1
	fi
else
	echo "skipping oh-my-bash installation."
fi

if [ "$setup_omb" != "${setup_omb#[Yy]}" ]; then
	cp -f $bashrc $home_dir/.bashrc
	echo "copied .bashrc to $home_dir"
fi

##
echo "removing existing neovim configuration directory..."
if rm -rf "$home_dir/code/dots/neovim-config"; then
	echo "directory removed successfully."
else
	echo "failed to remove directory."
	exit 1
fi

echo "cloning neovim configuration repository..."
if git clone https://github.com/mkonji008/neovim-config "$home_dir/code/dots/neovim-config"; then
	echo "neovim-config cloned successfully."
else
	echo "failed to clone neovim-config."
	exit 1
fi

echo "copying neovim '$home_dir/code/dots/neovim-config/' to '$home_dir/.config/nvim'..."
if mkdir -p "$home_dir/.config/nvim" && cp -rT "$home_dir/code/dots/neovim-config/" "$home_dir/.config/nvim"; then
	echo "neovim config copied successfully"
else
	echo "failed to copy neovim config"
fi

##
echo "copying .config '$home_dir/nix-config/dots/dotconfig/' to '$home_dir/.config'..."
if mkdir -p "$home_dir/.config" && cp -rT "$home_dir/nix-config/dots/dotconfig/" "$home_dir/.config"; then
	echo ".config copied successfully"
else
	echo "failed to copy .config"
fi

##
echo "copying .local '$home_dir/nix-config/dots/dotlocal' to '$home_dir/.local'..."
if mkdir -p "$home_dir/.local/share" && cp -rT "$home_dir/nix-config/dots/dotlocal/" "$home_dir/.local/"; then
	echo ".local copied successfully"
else
	echo "failed to copy .local"
fi

##
echo "copying wallpaper '$home_dir/nix-config/dots/wallpaper' to '$home_dir/Pictures'..."
if mkdir -p "$home_dir/Pictures/wallpaper" && cp -rT "$home_dir/nix-config/dots/wallpaper/" "$home_dir/Pictures/wallpaper"; then
	echo "wallpapers copied successfully"
else
	echo "failed to copy wallpapers"
fi

##
echo "changing ownership of $home_dir"
if chown -R "$user_name" "$home_dir"; then
	echo "ownership changed."
else
	echo "failed to change ownership."
	exit 1
fi

echo "changing permissions to drwxr-xr-x of $home_dir for $user_name"
if chmod -R 775 "$home_dir"; then
	echo "drwxr-xr-x changed for $user_name."
else
	echo "failed to change permissions."
	exit 1
fi

##
echo "configuration updated, system rebuilt, neovim configuration cloned, and dotfiles copied successfully..hopefully <3"
