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

read -p "$(echo -e "${yellow}Do you want to configure display resolution? (y/n): ${reset}")" configure_resolution
if [ "$configure_resolution" = "y" ]; then
	echo -e "${blue}Available display configurations:${reset}"
	xrandr | grep -w connected | while read -r line; do
		monitor=$(echo "$line" | awk '{print $1}')
		echo -e "${blue}Monitor: $monitor${reset}"
		read -p "${blue}Enter the desired mode (e.g., 1920x1080): ${reset}" mode
		read -p "${blue}Enter the refresh rate (e.g., 60): ${reset}" refresh_rate

		xrandr --output $monitor --mode $mode --rate $refresh_rate
	done

	echo -e "${blue}Do the displays look okay with the new configurations? (y/n)${reset}"
	read confirm
	if [ "$confirm" != "y" ]; then
		echo -e "${red}Reverting changes.${reset}"
		exit 1
	fi

	echo -e "${green}Display configurations applied.${reset}"

	tmp_file=$(mktemp)

	echo "#!/bin/bash" >$tmp_file
	echo "set -e" >>$tmp_file
	echo "" >>$tmp_file

	xrandr | grep -w connected | while read -r line; do
		monitor=$(echo "$line" | awk '{print $1}')
		echo "xrandr --output $monitor --mode $mode --rate $refresh_rate --rotate $orientation" >>$tmp_file
	done

	cp $tmp_file $home_dir/.config/screenlayout.sh

	chown $user_name $home_dir/.config/screenlayout.sh
	chmod +x $home_dir/.config/screenlayout.sh

	rm $tmp_file

	echo -e "${green}Display resolution set.${reset}"
	echo -e "${green}xrandr config saved to $home_dir/.config/screenlayout.sh${reset}"
	echo -e "${green}Configuration file made executable.${reset}"
else
	echo -e "${yellow}Skipping display resolution configuration.${reset}"
fi
echo -e "${blue}Setting wallpaper.${reset}"
if ! nitrogen --set-zoom $home_dir/Pictures/wallpaper1.png; then
	echo -e "${red}Error setting wallpaper.${reset}"
fi
