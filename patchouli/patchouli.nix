{ config, lib, pkgs, ... }:

let
  patched-discord = pkgs.discord.override { nss = pkgs.nss_latest; };
in
{
  nixpkgs.config.allowUnfree = true;
  home.username = "patchouli";
  home.homeDirectory = "/home/patchouli";

  imports =
    [ ./fontconfig.nix ./waybar.nix ./systemd-units.nix ./terminal.nix ];

  home.packages = with pkgs; [
    # Dev
    git
    git-crypt
    gnupg
    gnumake
    #openjdk8
    adoptopenjdk-hotspot-bin-8
    (pkgs.callPackage ../pkgs/codeship-jet/default.nix { })

    # Multimedia
    firefox-wayland
    #chromium # I hate the browser hegemony i hate the browser hegemony
    thunderbird
    zathura # PDF viewer
    imv # Image Vewer, Feh for wayland
    ueberzug # Show images in ranger
    mpv

    # Wayland stuff
    wl-clipboard
    mako
    alacritty
    dmenu
    autotiling
    waybar
    slurp

    # Communication
    #(discord.override {nss = pkgs.nss_latest;})
    patched-discord
    (pkgs.mumble.override { pulseSupport = true; })
    slack

    # Audio and Music
    pavucontrol
    spotify

    # Documents
    texlive.combined.scheme-full

    # Nix specific stuff
    nixfmt
    nil

    # Utilities
    mons
    htop
    ripgrep
    sshfs
    direnv
    fishPlugins.pure
    flameshot
    grim

    # File Management
    ranger
    unzip
    unrar

    # Security
    keepassxc
    yubioath-desktop
    mullvad-vpn

    # DB stuff
    sqlite

    #Games
    prismlauncher-qt5
    # Needed for vic3
    ncurses
  ];

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
      output HDMI-A-2 pos 0 0 res 1920x1080
      output DP-1 pos 1920 0 res 2560x1440
      output HDMI-A-1 pos 4480 0 res 1920x1080
      workspace 3 output HDMI-A-2
      workspace 2 output HDMI-A-1
      workspace 1 output DP-1
      smart_gaps on
      smart_borders on
      bindsym Mod1+0 workspace number 10
      bindsym Print exec 'grim -g "$(slurp)" - | wl-copy -t image/png'
      bindsym Mod1+Shift+0 move container to workspace number 10
      bindsym Mod1+Shift+Control+p exec "systemctl poweroff"
      bar swaybar_command waybar
      exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
      exec hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
    '';
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages
      (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkNativeComp;
    extraPackages = (epkgs: [ epkgs.vterm epkgs.emacsql-sqlite ]);
  };

  home.stateVersion = "22.05";
}