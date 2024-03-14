# nix-config

NixOS + i3, desktop set up for development

## Setup for for my personal NixOS development box.

1.  Perform a minimal install with no desktop, either with the minimal iso or gui ensuring that root user is enabled.
2.  Once that is completed after reboot, log in to the tty and run- <br>
    `nix-shell -p git`<br>
    _This will temporary install git to be able to pull down the repo._
3.  once that completes run- <br>
    `git clone https://github.com/mkonji008/nix-config`
4.  cd into **nix-config** and verify the packages in **configuration.nix**. By default I have it set to for my personal dev-box. There are also packages for a more full featured system with a touch of uncommenting.
5.  Once packages have been verified, jump into root/su <br>
    as root user, execute setup <br>
    `./setup.sh`

        This will prompt for a few things along the way, ask for username, auto set up home dir, copy dotfiles, change to nix-unstable channel, set up oh-my-bash, pull down and copy my personal neovim dotfiles from repo, copy configuration.nix, set up git config.<br>

6.  Reboot the system and you should be greeted with a login manager - **lightdm**
7.  Once logged in **super+enter** opens a terminal, to view i3 hotkeys run<br>
    `bat ~/.config/i3/config`<br> I will also include hotkeys and navigation at the end of this README.
    Assuming some window manager knowledge but this uses rofi to open files **super+d** and to see the bar it's expecting **super** key to be held to be visible.

8.  There is an optional script to define monitors and prompt for desired resolution for a multi monitor setup. The script is called<br>
    `opt_setdisplay.sh` <br>
    One may also just use the gui tool arandr or xrandr for cli.

**TODO:** create find and replace for setup task to replace all instances of mkonji with the username entered in the **setup** script.<br>
Currently all dotfiles the username is hard coded to mkonji but only temporary.

## Navigation and Hotkeys

### Movement and Focus

**mod = super key**

- `$mod+h`: Focus left
- `$mod+j`: Focus down
- `$mod+k`: Focus up
- `$mod+l`: Focus right
- `$mod+Left`: Focus left (alternatively)
- `$mod+Down`: Focus down (alternatively)
- `$mod+Up`: Focus up (alternatively)
- `$mod+Right`: Focus right (alternatively)

### Window Manipulation

- `$mod+Shift+h`: Move window left
- `$mod+Shift+j`: Move window down
- `$mod+Shift+k`: Move window up
- `$mod+Shift+l`: Move window right
- `$mod+Shift+Left`: Move window left (alternatively)
- `$mod+Shift+Down`: Move window down (alternatively)
- `$mod+Shift+Up`: Move window up (alternatively)
- `$mod+Shift+Right`: Move window right (alternatively)
- `$mod+b`: Split in horizontal orientation
- `$mod+v`: Split in vertical orientation
- `$mod+space`: Enter fullscreen mode for the focused container
- `$mod+f`: Toggle focus between tiling / floating windows
- `$mod+p`: Focus the parent container
- `$mod+Shift+space`: Toggle tiling / floating

### Workspaces

- `$mod+1`: Switch to workspace 1
- `$mod+2`: Switch to workspace 2
- `$mod+3`: Switch to workspace 3
- `$mod+4`: Switch to workspace 4
- `$mod+5`: Switch to workspace 5
- `$mod+6`: Switch to workspace 6
- `$mod+7`: Switch to workspace 7
- `$mod+8`: Switch to workspace 8
- `$mod+9`: Switch to workspace 9
- `$mod+0`: Switch to workspace 10
- `$mod+Shift+1`: Move focused container to workspace 1
- `$mod+Shift+2`: Move focused container to workspace 2
- `$mod+Shift+3`: Move focused container to workspace 3
- `$mod+Shift+4`: Move focused container to workspace 4
- `$mod+Shift+5`: Move focused container to workspace 5
- `$mod+Shift+6`: Move focused container to workspace 6
- `$mod+Shift+7`: Move focused container to workspace 7
- `$mod+Shift+8`: Move focused container to workspace 8
- `$mod+Shift+9`: Move focused container to workspace 9
- `$mod+Shift+0`: Move focused container to workspace 10

### Resize Mode

- `$mod+r`: Enter resize mode
- In resize mode:
  - `h` or `Left`: Shrink width
  - `j` or `Down`: Grow height
  - `k` or `Up`: Shrink height
  - `l` or `Right`: Grow width
  - `Return`, `Escape`, or `$mod+r`: Exit resize mode

## Other Hotkeys

- `$mod+w`: Open main browser - floorp
- `$mod+Shift+w`: Open alternate browser - qutebrowser
- `$mod+e`: Open file manager - thunar
- `$mod+Return`: Open terminal - xfce-terminal
- `$mod+a`: Open pulseaudio control - pavucontrol
- `$mod+q`: Close window
- `$mod+Shift+q`: Kill targeted X window with mouse
- `$mod+Shift+Escape`: Lock the display
- `$mod+d`: Open application search window - rofi
- `$mod+x`: Show open windows with rofi
- `$mod+Shift+c`: Reload the configuration file
- `$mod+Shift+r`: Restart i3
- `$mod+Shift+e`: Exit i3
