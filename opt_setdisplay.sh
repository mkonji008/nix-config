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

read -p "${blue}do you want to configure display resolution? (y/n): ${reset}" configure_resolution
if [ "$configure_resolution" != "y" ]; then
	echo "${yellow}skipping display resolution configuration.${reset}"
else
	# prompt the user for display resolution
	echo "${green}available display resolutions:${reset}"
	xrandr | grep -w connected | awk '{print $1, $3}'
	read -p "${blue}enter the desired display resolution (e.g., 1920x1080): ${reset}" resolution
	# apply the chosen resolution
	connected_monitors=$(xrandr | grep -w connected | awk '{print $1}')
	for monitor in $connected_monitors; do
		xrandr --output $monitor --mode $resolution
	done
	# confirm the applied resolution
	echo "${blue}does the display look okay with the new resolution? (y/n)${reset}"
	read confirm
	if [ "$confirm" != "y" ]; then
		echo "${red}reverting changes.${reset}"
		exit 1
	fi
	echo "#!/bin/bash" >$home_dir/.config/screenlayout.sh
	echo "xrandr --output $(xrandr | grep -w connected | awk '{print $1}') --mode $resolution" >>$tmp_file
	echo "${green}display resolution set to $resolution${reset}"
	echo "${green}configuration saved to $home_dir/.config/screenlayout.sh${reset}"
	chown $user_name $home_dir/.config/screenlayout.sh
	su $user_name -c "chmod +x $home_dir/.config/screenlayout.sh"
	echo "${green}screenlayout.sh made executable.${reset}"
fi

echo -e "${blue}Setting wallpaper.${reset}"
if ! nitrogen --set-zoom $home_dir/Pictures/wallpaper3.jpg; then
	echo -e "${red}Error setting wallpaper.${reset}"
fi
