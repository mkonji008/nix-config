#!/usr/bin/env bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;94m'
reset='\033[0m'

read -p "$(echo -e "${blue}enter username: ${reset}")" user_name

read -p "$(echo -e "${blue}is '${user_name}' the correct username? (y/n): ${reset}")" username_confirm
if [[ $username_confirm != "y" && $username_confirm != "Y" ]]; then
	echo -e "${red}error: username not confirmed.${reset}"
	exit 1
fi

if ! id -u "$user_name" &>/dev/null; then
	echo -e "${red}error: username '${user_name}' not found.${reset}"
	exit 1
fi

home_dir="/home/$user_name"

##
default_dirs=(".config" "Documents" "Downloads" "Music" "Pictures" "Videos" "code" "code/dots" "code/tmp" "code/ext" "/code/prj")

for dir in "${default_dirs[@]}"; do
	if [ ! -d "$home_dir/$dir" ]; then
		echo -e "${yellow}creating directory '${home_dir}/${dir}'...${reset}"
		mkdir -p "$home_dir/$dir" || {
			echo -e "${red}error: failed to create directory '${home_dir}/${dir}'${reset}"
			exit 1
		}
		echo -e "${green}directory created successfully.${reset}"
	else
		echo -e "${yellow}directory '${home_dir}/${dir}' already exists, skipping creation.${reset}"
	fi
done

##
echo -e "${yellow}checking current nixos channel...${reset}"
current_channel=$(nix-channel --list | grep 'nixos https://nixos.org/channels/nixos-unstable')
if [[ -z "$current_channel" ]]; then
	echo -e "${yellow}not currently on nixos unstable channel, updating channels...${reset}"
	nix-channel --remove nixos
	nix-channel --add https://nixos.org/channels/nixos-unstable nixos
	nix-channel --update || {
		echo -e "${red}error: failed to update nixos channels.${reset}"
		exit 1
	}
	echo -e "${green}nixos channels updated successfully.${reset}"
else
	echo -e "${yellow}nixos already on unstable channel, skipping update.${reset}"
fi

##
read -p "$(echo -e "${blue}copy configuration.nix and hardware-configuration.nix to /etc/nixos/? (y/n) ${reset}")" -r confirm_nix_copy
if [[ "$confirm_nix_copy" =~ ^[yy]$ ]]; then
	echo -e "${yellow}copying configuration files...${reset}"
	cp -f configuration.nix /etc/nixos/
	#  cp -f hardware-configuration.nix /etc/nixos/
	echo -e "${green}configuration files copied.${reset}"

	echo -e "${yellow}rebuilding nixos configuration...${reset}"
	nixos-rebuild switch || {
		echo -e "${red}error: failed to rebuild nixos configuration.${reset}"
		exit 1
	}
	echo -e "${green}nixos configuration rebuilt.${reset}"
else
	echo -e "${yellow}skipping configuration file copy.${reset}"
fi

##
bashrc="$home_dir/nix-config/dots/.bashrc"

read -p "$(echo -e "${blue}setup oh-my-bash? (y/n) ${reset}")" setup_omb

if [ "$setup_omb" != "${setup_omb#[Yy]}" ]; then
	doas -u $user_name bash -c 'bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)" &'

	while [[ $(jobs | wc -l) -gt 0 ]]; do
		sleep 1
	done

	if [ $? -eq 0 ]; then
		echo -e "${green}oh-my-bash installed successfully.${reset}"
	else
		echo -e "${red}error: oh-my-bash installation failed.${reset}"
		exit 1
	fi
else
	echo -e "${yellow}skipping oh-my-bash installation.${reset}"

fi
if [ "$setup_omb" != "${setup_omb#[Yy]}" ]; then
	cp -f $bashrc $home_dir/.bashrc
	echo -e "${green}copied .bashrc to $home_dir${reset}"
fi

##
echo -e "${yellow}removing existing neovim configuration directory...${reset}"
if rm -rf "$home_dir/code/dots/neovim-config"; then
	echo -e "${green}directory removed successfully.${reset}"
else
	echo -e "${red}failed to remove directory.${reset}"
	exit 1
fi

echo -e "${yellow}cloning neovim configuration repository...${reset}"
if git clone https://github.com/mkonji008/neovim-config "$home_dir/code/dots/neovim-config"; then
	echo -e "${green}neovim-config cloned successfully.${reset}"
else
	echo -e "${red}failed to clone neovim-config.${reset}"
	exit 1
fi

echo -e "${yellow}copying neovim '$home_dir/code/dots/neovim-config/' to '$home_dir/.config/nvim'...${reset}"
if mkdir -p "$home_dir/.config/nvim" && cp -rT "$home_dir/code/dots/neovim-config/" "$home_dir/.config/nvim"; then
	echo -e "${green}neovim config copied successfully${reset}"
else
	echo -e "${red}failed to copy neovim config${reset}"
fi

##
echo -e "${yellow}copying .config '$home_dir/nix-config/dots/dotconfig/' to '$home_dir/.config'...${reset}"
if mkdir -p "$home_dir/.config" && cp -rT "$home_dir/nix-config/dots/dotconfig/" "$home_dir/.config"; then
	echo -e "${green}.config copied successfully${reset}"
else
	echo -e "${red}failed to copy .config${reset}"
fi

##
echo -e "${yellow}copying .local '$home_dir/nix-config/dots/dotlocal' to '$home_dir/.local'...${reset}"
if mkdir -p "$home_dir/.local/share" && cp -rT "$home_dir/nix-config/dots/dotlocal/" "$home_dir/.local/"; then
	echo -e "${green}.local copied successfully${reset}"
else
	echo -e "${red}failed to copy .local${reset}"
fi

##
echo -e "${yellow}copying wallpaper '$home_dir/nix-config/dots/wallpaper' to '$home_dir/Pictures'...${reset}"
if mkdir -p "$home_dir/Pictures/wallpaper" && cp -rT "$home_dir/nix-config/dots/wallpaper/" "$home_dir/Pictures/wallpaper"; then
	echo -e "${green}wallpapers copied successfully${reset}"
else
	echo -e "${red}failed to copy wallpapers${reset}"
fi

##
echo -e "${green}create symlink for floorp $home_dir${reset}"
if su $user_name -c "ln -sfn \"$home_dir/.config/.floorp\" \"$home_dir/.floorp\""; then
	echo -e "${green}created symlink for floorp${reset}"
else
	echo -e "${red}error: symlink creation failed.${reset}" >&2
fi

##
echo -e "${yellow}changing ownership of $home_dir${reset}"
if chown -R "$user_name" "$home_dir"; then
	echo -e "${green}ownership changed.${reset}"
else
	echo -e "${red}failed to change ownership.${reset}"
	exit 1
fi

echo -e "${yellow}changing permissions to drwxr-xr-x of $home_dir for $user_name${reset}"
if chmod -R 775 "$home_dir"; then
	echo -e "${green}drwxr-xr-x changed for $user_name.${reset}"
else
	echo -e "${red}failed to change permissions.${reset}"
	exit 1
fi

##
su -l $user_name -c "

echo -e '${blue}enter your git username:${reset}'
read git_username

echo -e '${blue}enter your git email:${reset}'
read git_email

echo -e '${blue}enter your text editor for git (e.g., nvim, emacs):${reset}'
read git_editor

git config --global user.name \"\$git_username\" && \
git config --global user.email \"\$git_email\" && \
git config --global core.editor \"\$git_editor\"

if [ \$? -ne 0 ]; then
    echo -e '${red}error: failed to configure git globals${reset}'
    exit 1
fi

cat ~/.gitconfig
"

read -p "$(echo -e "${blue}is the configuration correct? (y/n): ${reset}")" verify

if [ "$verify" != "y" ]; then
	echo -e "${red}configuration not confirmed. exiting.${reset}"
	exit 1
fi

echo -e "${green}git globals configured successfully.${reset}"

##
echo -e "${green}configuration updated, system rebuilt, neovim configuration cloned, and dotfiles copied successfully..hopefully <3${reset}"
