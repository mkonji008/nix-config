#!/usr/bin/env bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;94m'
reset='\033[0m'

read -p "$(echo -e "${blue}Enter username: ${reset}")" user_name

read -p "$(echo -e "${blue}Is '${user_name}' the correct username? (y/n): ${reset}")" username_confirm
if [[ $username_confirm != "y" && $username_confirm != "Y" ]]; then
	echo -e "${red}Error: Username not confirmed.${reset}"
	exit 1
fi

if ! id -u "$user_name" &>/dev/null; then
	echo -e "${red}Error: Username '${user_name}' not found.${reset}"
	exit 1
fi

home_dir="/home/$user_name"

read -p "$(echo -e "${blue}Do you want to configure display resolution? (y/n): ${reset}")" configure_resolution
if [ "$configure_resolution" != "y" ]; then
	echo "${yellow}Skipping display resolution configuration.${reset}"
else
	echo "${green}Available display configurations:${reset}"
	xrandr | grep -w connected | while read -r line; do
		monitor=$(echo "$line" | awk '{print $1}')
		echo "${blue}Monitor: $monitor${reset}"

		read -p "${blue}Enter the desired resolution for $monitor (e.g., 1920x1080): ${reset}" resolution

		read -p "${blue}Enter the desired refresh rate for $monitor (e.g., 60): ${reset}" refresh_rate

		read -p "${blue}Enter the desired orientation for $monitor (normal/left/right/inverted): ${reset}" orientation

		xrandr --output $monitor --mode $resolution --rate $refresh_rate --rotate $orientation
	done

	echo "${blue}Do the displays look okay with the new configurations? (y/n)${reset}"
	read confirm
	if [ "$confirm" != "y" ]; then
		echo "${red}Reverting changes.${reset}"
		exit 1
	fi

	config_file="$home_dir/.config/screenlayout.sh"
	echo "#!/bin/bash" >$config_file
	echo "xrandr --output $(xrandr | grep -w connected | awk '{print $1}') --mode $resolution --rate $refresh_rate --rotate $orientation" >>$config_file
	chmod +x $config_file

	echo "${green}Display resolution set.${reset}"
	echo "${green}Configuration saved to $config_file${reset}"
fi

echo -e "${blue}Setting wallpaper.${reset}"
if ! nitrogen --set-zoom $home_dir/Pictures/wallpaper3.jpg; then
	echo -e "${red}Error setting wallpaper.${reset}"
fi
