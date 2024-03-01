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
      layout = "us";

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
        autoLogin = {
          enable = false;
          user = "mkonji";
          };
        };
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
   xfce.xfconf
   kdePackages.kdeconnect-kde
   eza
   font-manager
   htop
   arandr
   bat
   bat
   btop
   bzip3
   cargo
   bitwarden-desktop
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
