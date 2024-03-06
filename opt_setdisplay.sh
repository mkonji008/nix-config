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
	exit 0
fi

echo "${green}Available display resolutions:${reset}"
xrandr | grep -w connected | awk '{print $1, $3}'
read -p "${blue}Enter the desired display resolution (e.g., 1920x1080): ${reset}" resolution

connected_monitors=$(xrandr | grep -w connected | awk '{print $1}')
for monitor in $connected_monitors; do
	xrandr --output $monitor --mode $resolution
done

echo "${blue}Does the display look okay with the new resolution? (y/n)${reset}"
read confirm
if [ "$confirm" != "y" ]; then
	echo "${red}Reverting changes.${reset}"
	exit 1
fi

config_file="$home_dir/.config/screenlayout.sh"
echo "#!/bin/bash" >$config_file
echo "xrandr --output $(xrandr | grep -w connected | awk '{print $1}') --mode $resolution" >>$config_file
chmod +x $config_file

echo "${green}Display resolution set to $resolution.${reset}"
echo "${green}Configuration saved to $config_file.${reset}"

##baseline
# read -p "$(echo -e "${blue}Do you want to configure display resolution? (y/n): ${reset}")" configure_resolution
# if [ "$configure_resolution" != "y" ]; then
# 	echo "${yellow}Skipping display resolution configuration.${reset}"
# 	exit 0
# fi
#
# echo "${green}Available display resolutions:${reset}"
# xrandr | grep -w connected | awk '{print $1, $3}'
# read -p "${blue}Enter the desired display resolution (e.g., 1920x1080): ${reset}" resolution
#
# connected_monitors=$(xrandr | grep -w connected | awk '{print $1}')
# for monitor in $connected_monitors; do
# 	xrandr --output $monitor --mode $resolution
# done
#
# echo "${blue}Does the display look okay with the new resolution? (y/n)${reset}"
# read confirm
# if [ "$confirm" != "y" ]; then
# 	echo "${red}Reverting changes.${reset}"
# 	exit 1
# fi
#
# config_file="$home_dir/.config/screenlayout.sh"
# echo "#!/bin/bash" >$config_file
# xrandr | grep -w connected | awk '{print "xrandr --output " $1 " --mode " $3}' >>$config_file
# chmod +x $config_file
#
# echo "${green}Display resolution set.${reset}"
# echo "${green}Configuration saved to $config_file${reset}"

echo -e "${blue}Setting wallpaper.${reset}"
if ! nitrogen --set-zoom $home_dir/Pictures/wallpaper/wallpaper1.png; then
	echo -e "${red}Error setting wallpaper.${reset}"
fi
