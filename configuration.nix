{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  documentation.nixos.enable = false;

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.enable = true;

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
  
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = [
        pkgs.fcitx5-mozc
        pkgs.fcitx5-gtk
        pkgs.fcitx5-configtool
    ]; 
  environment.variables.GLFW_IM_MODULE = "ibus";


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
  # mainApplications
    # optWork
       slack
       teams-for-linux
       zoom-us
    # browsers
       brave
       floorp 
       qutebrowser
    # media
       cmus
       ffmpeg #codec
       foliate
       mplayer
       strawberry
       vlc
       zathura
    # editing
       darktable
       kdePackages.kdenlive
       krita
       upscayl
    # office 
       libreoffice
       obsidian
    # misc
       bitwarden-desktop 
       copyq
       filezilla
       flameshot
       kdePackages.kdeconnect-kde 
       remmina
       tutanota-desktop
    # downloading
       deluge-gtk
       tartube
       yt-dlp
       ytdownloader
    # ai tooling
       #gpt4all
       tgpt
    # keyboard
       qmk
       via
       vial
    #personalNonDev
         # optGame
            #heroic-unwrapped
            #lutris-unwrapped
            #openmw
            #protonup-ng
            #protonup-qt
            #steam
            #steam-run
         # optVintageUtils
            #kdePackages.k3b ## iso disc burning
            #ufiformat ## usb floppy formatter
         # chat
            #discord
            #signal-desktop
  # devPackages
      # cliTools
         bat
         btop
         cron
         curl
         elinks
         eza
         fzf
         git
         gnugrep
         htop
         mlocate
         neofetch
         neovim
         ranger
         ripgrep
         tldr
         tmux
         trash-cli
         w3m
         wget
         xclip
         zoxide
      # virtTools
         qemu
         virt-manager
      # devTools
         #docker
         #docker-compose
         #terraform-providers.
         #terraform-providers.ansible
         #terraform-providers.aws
         #terraform-providers.dns
         #terraform-providers.google
         #terraform-providers.helm
         #terraform-providers.postgresql
         #terraform-providers.utils
         #terraform-providers.vault
         ansible
         awscli2
         distrobox
         github-desktop
         k3d
         kargo
         plumber
         podman
         podman-compose
         podman-tui
         pods
         rancher
         terraform
         terraform-inventory
         terraformer
      # langsRelated-req
         # c/c++/universal c
            clang-tools_9
            cmake
            gcc
            libgcc
         # go
            air
            go
            hugo
         # rust  
            cargo
            rustc
            rustup
         # js/ts
            bun
            nodePackages.npm
            nodejs_21
            typescript
         # python
            python3Full
            yamllint
         # miscLang
            dex
  # baseSystem&WM-req
     # miscReq
        doas
        flatpak
        gnumake
        openssl
        os-prober
      # hardwareTools
         amdctl
         amdgpu_top
         lm_sensors
         psendor
     # windowManager
        arandr
        dunst
        font-manager
        fontconfig
        gnome.gnome-keyring
        i3
        lxappearance
        nitrogen
        picom
        polkit_gnome
        rofi
        xdg-desktop-portal-gtk
        xfce.ristretto
        xfce.thunar
        xfce.xfce4-power-manager
        xfce.xfce4-terminal
        xfce.xfconf
     # networking
        tailscale
        networkmanager-openvpn
        networkmanagerapplet
     # backupDisksStorage
        dosfstools
        fuse-common
        google-drive-ocamlfuse
        gparted
        psmisc
        rsync
        syncthing
        timeshift-unwrapped
        usbutils
        util-linux
        smbnetfs
     # systemAudio
        noisetorch
        pavucontrol
        pulseaudioFull
     # zip&CompressionTools
        bzip3
        gzip
        p7zip
        rar
        unzip
        xarchiver
        xz
        zip
     # themes
        gruvbox-dark-gtk
        gruvbox-gtk-theme
        onestepback
        shades-of-gray-theme
        xfce.xfwm4-themes
     # icons
        gruvbox-dark-icons-gtk
        gruvbox-plus-icons
        material-black-colors
        numix-icon-theme
        oranchelo-icon-theme
     # cursors
        capitaine-cursors
        material-cursors
        phinger-cursors
        simp1e-cursors
        vimix-cursors
        xorg.xcursorthemes
   #(compile errors) use flatpak
      #rustdesk
      #vault
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
