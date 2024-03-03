#!/usr/bin/env bash

read -p "enter username: " user_name

read -p "is '$user_name' the correct username? (y/n): " username_confirm
if [[ $username_confirm != "y" && $username_confirm != "Y" ]]; then
    echo "error: username not confirmed."
    exit 1
fi

if ! id -u "$user_name" &> /dev/null; then
  echo "error: username '$user_name' not found."
  exit 1
fi

home_dir="/home/$user_name"

default_dirs=( ".config" "Documents" "Downloads" "Music" "Pictures" "Videos" "code" "code/dots" "code/tmp" "code/ext" "/code/prj" )

for dir in "${default_dirs[@]}"; do
  if [ ! -d "$home_dir/$dir" ]; then
    echo "creating directory '$home_dir/$dir'..."
    mkdir -p "$home_dir/$dir" || { echo "error: failed to create directory '$home_dir/$dir'"; exit 1; }
    echo "directory created successfully."
  else
    echo "directory '$home_dir/$dir' already exists, skipping creation."
  fi
done

echo "checking current nixos channel..."
current_channel=$(nix-channel --list | grep 'nixos https://nixos.org/channels/nixos-unstable')
if [[ -z "$current_channel" ]]; then
  echo "not currently on nixos unstable channel, updating channels..."
  nix-channel --remove nixos
  nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  nix-channel --update || { echo "error: failed to update nixos channels."; exit 1; }
  echo "nixos channels updated successfully."
else
  echo "nixos already on unstable channel, skipping update."
fi

echo "rebuilding nixos configuration..."
nixos-rebuild switch || { echo "error: failed to rebuild nixos configuration."; exit 1; }
echo "nixos configuration rebuilt."

read -p "copy configuration.nix and hardware-configuration.nix to /etc/nixos/? (y/n) " -r confirm_nix_copy
if [[ "$confirm_nix_copy" =~ ^[yy]$ ]]; then
  echo "copying configuration files..."
  cp -f configuration.nix /etc/nixos/
  cp -f hardware-configuration.nix /etc/nixos/
  echo "configuration files copied."
else
  echo "skipping configuration file copy."
fi

neovim_config_dir="$home_dir/code/dots/neovim-config"
if [ -d "$neovim_config_dir" ]; then
  echo "neovim configuration directory already exists, updating it..."
  (cd "$neovim_config_dir" && git fetch --depth=1 && git reset --hard origin/main) || { echo "error: failed to update neovim configuration."; exit 1; }
  echo "neovim configuration updated successfully."
else
  echo "cloning neovim configuration repository..."
  git clone --depth=1 https://github.com/mkonji008/neovim-config "$neovim_config_dir" || { echo "error: failed to clone neovim configuration."; exit 1; }
  echo "neovim configuration cloned successfully."
fi

echo "copying neovim '$home_dir/code/dots/nvim-config' to '$home_dir/.config/nvim'..."
if mkdir -p "$home_dir/.config/nvim" && cp -r "$home_dir/code/dots/nvim-config" "$home_dir/.config/nvim"; then
  echo "neovim config copied successfully"
else
  echo "failed to copy neovim config"
fi


echo "configuration updated, system rebuilt, neovim configuration cloned, and dotfiles copied successfully."
