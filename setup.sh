#!/usr/bin/env bash

user_name=$(whoami)

home_dir="/home/$user_name"

default_dirs=( ".config" "Documents" "Downloads" "Music" "Pictures" "Videos" "code" "code/dots" "code/tmp" "code/ext" "/code/prj" )

check_error() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

run_with_sudo() {
  echo "this step requires sudo privileges. Please enter your password when prompted:"
  sudo "$@" || check_error "failed to execute command: $@"
}

if ! su - "$user_name" -c "mkdir -p '$home_dir'" || ! chown "$user_name" "$home_dir"; then
  check_error "failed to create or set permissions for home directory '$home_dir'."
fi

for dir in "${default_dirs[@]}"; do
  if ! su - "$user_name" -c "mkdir -p '$home_dir/$dir'" || ! chown "$user_name" "$home_dir/$dir"; then
    check_error "failed to create or set permissions for directory '$home_dir/$dir'."
  fi
done

chgrp "$user_name" "$home_dir"

echo "switching to nixos unstable channel..."
run_with_sudo nix-channel --remove nixos
run_with_sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
run_with_sudo nix-channel --update

##rebuild after a channel update, was getting an error if skipped
run_with_sudo nixos-rebuild switch

config_path="/home/$user_name/nix-config/configuration.nix

echo "copying configuration.nix..."
run_with_sudo cp "$config_path" /etc/nixos/configuration.nix

echo "rebuilding nixos configuration..."
run_with_sudo nixos-rebuild switch

echo "cloning dotfiles..."
git clone https://github.com/mkonji008/dotfiles "$home_dir/code/dots" || check_error "Failed to clone dotfiles repository."

## example, will update 
source_target_pairs=(
  "/path/to/source/directory1" "$home_dir/.config/dir1"
  "/path/to/source/directory2" "$home_dir/.local/share/dir2"
  "/path/to/source/directory3" "$home_dir/Documents/dir3"
  "/path/to/source/directory4" "$home_dir/Downloads/dir4"
  "/path/to/source/directory5" "$home_dir/Pictures/dir5"
  "/path/to/source/directory6" "$home_dir/Videos/dir6"
)

echo "Copying directories and their contents to specific targets..."
for pair in "${source_target_pairs[@]}"; do
  source_dir="${pair%%=*}"  #path extract
  target_dir="${pair#*=}"   #path extract

  if ! cp -r "$source_dir" "$target_dir"; then
    check_error "failed to copy directory '$source_dir' to '$target_dir'."
  fi
done

echo "configuration updated and system rebuilt successfully, sudo is gone, use doas"
