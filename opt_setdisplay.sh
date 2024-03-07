#!/usr/bin/env bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;94m'
reset='\033[0m'

read -p "$(echo -e "${blue}enter username: ${reset}")" user_name

read -p "$(echo -e "${blue}Is '${user_name}' the correct username? (y/n): ${reset}")" username_confirm
if [[ $username_confirm != "y" && $username_confirm != "Y" ]]; then
	echo -e "${red}error: username not confirmed.${reset}"
	exit 1
fi

if ! id -u "$user_name" &>/dev/null; then
	echo -e "${red}error: username '${user_name}' not found.${reset}"
	exit 1
fi

home_dir="/home/$user_name"

read -p "$(echo -e "${blue}do you want to configure display resolution? (y/n): ${reset}")" configure_resolution
if [ "$configure_resolution" != "y" ]; then
	echo -e "${yellow}skipping display resolution configuration.${reset}"
	exit 0
fi

echo -e "${green}available monitors:${reset}"
xrandr | grep -w connected | awk '{print $1, $3}'
read -p "$(echo -e "${blue}enter the desired display resolution (e.g., 1920x1080): ${reset}")" resolution

read -p "$(echo -e "${blue}enter the desired refresh rate (e.g., 60): ${reset}")" refresh_rate

read -p "$(echo -e "${blue}enter the desired orientation (e.g., normal/left/right/inverted): ${reset}")" orientation

connected_monitors=$(xrandr | grep -w connected | awk '{print $1}')
for monitor in $connected_monitors; do
	xrandr --output $monitor --mode $resolution --rate $refresh_rate --rotate $orientation
done

config_file="$home_dir/.config/screenlayout.sh"
echo "#!/usr/bin/env bash" >$config_file
echo "xrandr --output $(xrandr | grep -w connected | awk '{print $1}') --mode $resolution --rate $refresh_rate --rotate $orientation" >>$config_file
chmod +x $config_file

bat $home_dir/.config/screenlayout.sh
echo -e "${blue}does the display look okay with the new configuration? (y/n)${reset}"
read confirm
if [ "$confirm" != "y" ]; then
	echo -e "${red}reverting changes.${reset}"
	exit 1
fi

##
echo -e "${blue}setting wallpaper.${reset}"
if ! nitrogen --set-zoom-fill $home_dir/Pictures/wallpaper/wallpaper1.png; then
	echo -e "${red}error setting wallpaper.${reset}"
fi
