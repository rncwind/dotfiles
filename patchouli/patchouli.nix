{ config, lib, pkgs, inputs, ... }:

let
  patched-discord = pkgs.discord-ptb.override { nss = pkgs.nss_latest; };
  ffxiv-wrapper = pkgs.writeScriptBin "ffxiv" ''
    #! ${pkgs.bash}/bin/bash
    export DXVK_FRAME_RATE=74
    exec gamemoderun XIVLauncher.Core "$@"
  '';
in
{

  nixpkgs.config.allowUnfree = true;
  home.username = "patchouli";
  home.homeDirectory = "/home/patchouli";

  imports =
    [ ./fontconfig.nix ./waybar.nix ./systemd-units.nix ./terminal.nix ./style.nix ./audio.nix ];

  home.packages = with pkgs; [
    # Dev
    git
    git-crypt
    gnupg
    gnumake
    #openjdk8
    #adoptopenjdk-hotspot-bin-8
    codeship-jet
    protobuf
    tig
    just
    fzf
    virt-manager
    virt-viewer
    postman

    # Cloud stuff
    google-cloud-sdk
    skaffold
    kubectl
    cloud-sql-proxy

    # Need some way of bootstrapping rust projects since there's no good flake
    # template for oxalica's overlay.
    rust-analyzer
    rust-bin.stable.latest.default

    # Multimedia
    firefox-wayland
    #chromium # I hate the browser hegemony i hate the browser hegemony
    thunderbird
    zathura # PDF viewer
    imv # Image Vewer, Feh for wayland
    ueberzug # Show images in ranger
    mpv
    rsgain

    # Wayland stuff
    wl-clipboard
    mako
    alacritty
    dmenu
    autotiling
    waybar
    slurp

    glib
    dracula-theme

    # Communication
    patched-discord
    codeship-jet
    slack

    # Audio and Music
    pavucontrol
    spotify
    picard
    soundkonverter
    chromaprint
    r128gain

    # Documents
    texlive.combined.scheme-full

    # Nix specific stuff
    nixfmt
    #nil
    rnix-lsp
    alejandra

    # Utilities
    mons
    htop
    ripgrep
    sshfs
    fishPlugins.pure
    flameshot
    grim
    oxipng
    fd # Faster find.
    remmina

    # File Management
    ranger
    unzip
    unrar
    xfce.thunar
    xfce.thunar-archive-plugin
    gnome.file-roller

    # Security
    keepassxc
    yubikey-manager
    mullvad-vpn
    polkit_gnome

    # DB stuff
    sqlite

    #Games

    # Actual Games
    (dwarf-fortress-packages.dwarf-fortress-full.override {
      theme = "spacefox";
      enableTruetype = 24;
    })
    prismlauncher-qt5
    vintagestory
    xivlauncher
    ffxiv-wrapper

    # Stuff for games
    jdk19_headless
    ncurses
    scanmem
    steamtinkerlaunch
    gamescope
    mangohud
    gamemode
    openal
    portaudio

    # Misc
    anki
    neofetch
    deluge
    nicotine-plus
  ];


  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # };

  programs.mako = {
    defaultTimeout = 10000;
    font = "hasklig 10";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
    config = {
      terminal = "alacritty";
      input."*" = {
        xkb_layout = "gb";
        xkb_options = "ctrl:nocaps";
        accel_profile = "flat";
        pointer_accel = "0.3";
      };
      bars = [ ];
    };
    extraConfig = ''
      gaps inner 10
      gaps outer 5
      exec_always autotiling
      output HDMI-A-1 pos 0 0 res 1920x1080
      output DP-1 pos 1920 0 res 2560x1440
      output HDMI-A-2 pos 4480 0 res 1920x1080
      workspace 3 output HDMI-A-1
      workspace 2 output HDMI-A-2
      workspace 1 output DP-1
      smart_gaps on
      smart_borders on
      bindsym Mod1+0 workspace number 10
      bindsym Print exec 'grim -g "$(slurp)" - | oxipng - --stdout -q -o5 --timeout 3 | wl-copy -t image/png'
      bindsym Mod1+Shift+0 move container to workspace number 10
      bindsym Mod1+Shift+Control+p exec "systemctl poweroff"
      bar swaybar_command waybar
      exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
      exec hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
      exec_always "systemctl --user import-environment; systemctl --user start sway-session.target"

      assign [app_id="slack"] 3
      assign [app_id="discord"] 3
    '';

    extraSessionCommands = ''
      export INPUT_METHOD=fcitx
      export QT_IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx
      export XIM_SERVERS=fcitx
    '';

  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages
      (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtk;
    extraPackages = (epkgs: [ epkgs.vterm ]);
  };

  programs.ncmpcpp = {
    enable = true;
    settings = {
      user_interface = "alternative";
      media_library_primary_tag = "album_artist";
    };
  };
  programs.ncspot = {
    enable = true;
    settings = {
      use_nerdfont = true;
      volnorm = true;
      bitrate = 320;
    };
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      use_pager = true;
      updates = {
        auto_update = true;
      };
    };
  };

  services.gammastep = {
    enable = true;
    temperature = {
      day = 6500;
      night = 2700;
    };
    tray = true;
    latitude = 51.5072;
    longitude = 0.12;
  };

  home.stateVersion = "22.05";
}
