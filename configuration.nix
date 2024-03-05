{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    kernelParams = ["nohibernate"];
    tmp.cleanOnBoot = true;
    supportedFilesystems = ["ntfs"];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        useOSProber = true;
        timeoutStyle = "menu";
      };
      timeout = 300;
    };
};
  networking.hostName = "nixbox";
  # networking.wireless.enable = true; 
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

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

  users.users.mkonji = {
    isNormalUser = true;
    description = "mkonji";
    extraGroups = [
      "flatpak"
      "disk"
      "qemu"
      "kvm"
      "libvirtd"
      "sshd"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "root"
    ];
  };

  services = {
    flatpak.enable = true;
    dbus.enable = true;
    picom.enable = true;
    qemuGuest.enable = true;

    xserver = {
      autorun = true;
      enable = true;
      windowManager.i3.enable = true;
      xkb.layout = "us";

      desktopManager.xterm.enable = true;

      displayManager = {
        defaultSession = "none+i3";
	lightdm = { 
	  enable = true;
          greeters.slick.enable = true;
          extraConfig = ''
            logind-check-graphical=true
             ''; 
##       setupCommands = ''
##         ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --mode 3840x1080 --pos 0x0 --rotate normal
##        '';
         };
      };
   };
{pkgs, ...}: {
  config = {
    i18n.inputMethod.enabled = "fcitx5";
    i18n.inputMethod.fcitx5.addons = [
      pkgs.fcitx5-mozc
      pkgs.fcitx5-gtk
      pkgs.fcitx5-configtool
    ]; 
    environment.variables.GLFW_IM_MODULE = "ibus";
  };
};
};

    security.doas.enable = true;
    security.sudo.enable = false;
    security.doas.extraRules = [{
      users = ["mkonji"];
      keepEnv = true;
      persist = true;
    }];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ 
   ansible
   arandr
   bat
   bat
   bitwarden-desktop
   btop
   bzip3
   cargo
   clang-tools_9
   cmake
   cmus
   copyq
   curl
   dex
   doas
   dosfstools
   dunst
   elinks
   eza
   filezilla
   flameshot
   flatpak
   floorp
   font-manager
   fontconfig
   fuse-common
   gcc
   git
   gnome.gnome-keyring
   gnugrep
   gnumake
   go
   google-drive-ocamlfuse
   gparted
   gzip
   htop
   i3
   kdePackages.kdeconnect-kde
   libgcc
   libreoffice
   lxappearance
   mlocate
   mplayer
   neofetch
   neovim
   networkmanager-openvpn
   networkmanagerapplet
   nitrogen
   nodePackages.npm
   nodejs_21
   openssl
   os-prober
   p7zip
   pavucontrol
   picom
   polkit_gnome
   protonup-ng
   pulseaudioFull
   python3
   qemu
   qutebrowser
   ranger
   rar
   remmina
   ripgrep
   rofi
   rustc
   steam
   steam-run
   terraform
   tldr
   tmux
   trash-cli
   unzip
   usbutils
   virt-manager
   vlc
   w3m
   w3m
   wget
   xarchiver
   xclip
   xdg-desktop-portal-gtk
   xfce.thunar
   xfce.xfce4-terminal
   xfce.xfconf
   xz
   yamllint
   zathura
   zip
 #(compile errors)  rustdesk
  ];

  console = {
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    useXkbConfig = true;
};
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override {fonts = ["Meslo"];})
    ];
    fontconfig = {
      enable = true;
     defaultFonts = {
       monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
       serif = ["Noto Serif" "Source Han Serif"];
       sansSerif = ["Noto Sans" "Source Han Sans"];
     };
    };
   }; 
    
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };  

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
    
    security.polkit.enable = true;

    virtualisation.libvirtd.enable = true;

  system.stateVersion = "23.11";

}
