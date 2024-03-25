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
       zoom-us
       slack
       teams-for-linux
    # browsers
       #brave
       floorp 
       qutebrowser
    # media
       vlc
       mplayer
       cmus
       strawberry
       foliate
       zathura
       ffmpeg #codec
    # editing
       krita
       darktable
       kdePackages.kdenlive
       upscayl
    # office 
       libreoffice
       obsidian
    # misc
       bitwarden-desktop 
       tutanota-desktop
       filezilla
       kdePackages.kdeconnect-kde 
       remmina
       flameshot
       copyq
    # downloading
       deluge-gtk
       yt-dlp
       tartube
    # keyboard
       vial
       via
       qmk
    #personalNonDev
         # optGame
            #heroic-unwrapped
            #lutris-unwrapped
            #openmw
            #protonup-ng
            #protonup-qt
            #steam
            #steam-run
         # optDiscUtils
            #kdePackages.k3b
         # chat
            #discord
            #signal-desktop
  # devPackages
      # cliTools
         tldr
         bat
         zoxide
         fzf
         git
         ripgrep
         tmux
         trash-cli
         eza
         ranger
         neovim
         mlocate
         htop
         btop
         neofetch
         elinks
         w3m
         wget
         curl
         cron
         gnugrep
         xclip
      # virtTools
         qemu
         virt-manager
      # devTools
         github-desktop
         ansible
         terraform
         #terraform-providers.ansible
         #terraform-providers.helm
         #terraform-providers.
         #terraform-providers.vault
         #terraform-providers.postgresql
         #terraform-providers.dns
         #terraform-providers.aws
         #terraform-providers.google
         #terraform-providers.utils
         terraformer
         terraform-inventory
         rancher
         k3d
         kargo
         #docker
         #docker-compose
         podman
         podman-tui
         podman-compose
         pods
         distrobox
         awscli2
         plumber
      # langsRelated-req
         # c/c++/universal c
            clang-tools_9
            gcc
            libgcc
            cmake
         # go
            go
            air
            hugo
         # rust  
            cargo
            rustc
            rustup
         # js/ts
            nodePackages.npm
            nodejs_21
            typescript
            bun
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
     # windowManager
        i3
        rofi
        picom
        polkit_gnome
        nitrogen
        xfce.xfce4-terminal
        xfce.xfconf
        xfce.thunar
        xfce.ristretto
        gnome.gnome-keyring
        fontconfig
        font-manager
        xdg-desktop-portal-gtk
        lxappearance
        arandr
        dunst
     # networking
        networkmanager-openvpn
        networkmanagerapplet
     # backupDisksStorage
        google-drive-ocamlfuse
        gparted
        rsync
        syncthing
        timeshift-unwrapped
        usbutils
        util-linux
        psmisc
        fuse-common
        dosfstools
     # systemAudio
        pulseaudioFull
        pavucontrol
        noisetorch
     # zip&CompressionTools
        unzip
        p7zip
        zip
        rar
        gzip
        bzip3
        xz
        xarchiver
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
