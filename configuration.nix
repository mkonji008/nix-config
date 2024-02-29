# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixbox"; # Define your hostname.
  # networking.wireless.enable = true; 
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mkonji = {
    isNormalUser = true;
    description = "mkonji";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

services.xserver.enable = true;
services.xserver.autorun = true;
#services.xserver.desktopManager.default = "none+i3";
services.xserver.desktopManager.xterm.enable = false;
services.xserver.windowManager.i3.enable = true;
services.qemuGuest.enable = true;
services.xserver.displayManager.lightdm = {
   enable = true;
   extraConfig = ''
   	logind-check-graphical=true
   '';
};
services.xserver.displayManager.lightdm.greeters.slick.enable = true;
services.xserver.displayManager.defaultSession = "none+i3";

## doas
security.doas.enable = true;
security.sudo.enable = false;
security.doas.extraRules = [{
   users = ["mkonji"];
   keepEnv = true;
   persist = true;
}];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

#  environment.systempackages = [
#   ];
#
#  _module.args.unstable-pkgs = import <nixos-unstable> {};


  environment.systemPackages = with pkgs; [ 
   kdePackages.kdeconnect-kde
   htop
   bat
   bat
   btop
   bzip3
   cargo
   clang-tools_9
   copyq
   curl
   doas
   dunst
   elinks
   filezilla
   flameshot
   flatpak
   floorp
   fontconfig
   fuse-common
   gcc
   nitrogen
   networkmanagerapplet
   google-drive-ocamlfuse
   qutebrowser
   networkmanager-openvpn
   dex
   libgcc
   git
   gnome.gnome-keyring
   gnugrep
   gnumake
   gparted
   lxappearance
   neofetch
   neovim
   openssl
   os-prober
   ansible
   cmake
   dosfstools
   go
   gzip
   i3
   arandr
   mlocate
   p7zip
   pavucontrol
   picom
   pulseaudioFull
   rar
   remmina
   rustc
   rustdesk
   terraform
   polkit_gnome
   protonup-ng
   qemu
   ranger
   ripgrep
   rofi
   steam
   steam-run
   tldr
   trash-cli
   virt-manager
   w3m
   wget
   xarchiver
   xclip
   xdg-desktop-portal-gtk
   xfce.thunar
   xfce.xfce4-terminal
   zathura
   libreoffice
   zip
   xz
   yamllint
   w3m
   vlc
   usbutils
   tmux
   mplayer
   cmus
   fira-code-nerdfont
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
