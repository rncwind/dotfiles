{ config, lib, pkgs, inputs, ... }:

let
  patched-discord = pkgs.discord-ptb.override { nss = pkgs.nss_latest; };
  ffxiv-wrapper = pkgs.writeScriptBin "ffxiv" ''
    #! ${pkgs.bash}/bin/bash
    export DXVK_FRAME_RATE=74
    exec gamemoderun XIVLauncher.Core "$@"
  '';
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };

in
{
  modules = {
    shell = {
      fish.enable = true;
      alacritty.enable = true;
      terminalPrograms.enable = true;
    };

    desktop = {
      sway.enable = true;
      desktop-utils.enable = true;
      audio = {
        music.enable = true;
      };
    };

    secrets = {
      enable = true;
      #expose = ["example_key"];
      expose = {example_key = {owner = config.users.users.patchouli.name;}; another_example = {};};
      keyFilePath = "/home/patchouli/.config/sops/age/keys.txt";
      secretsFile = ../secrets/users/patchouli.yaml;
    };
  };

  # sops.age.keyFile = "/home/patchouli/.config/sops/age/keys.txt";
  # sops.defaultSopsFile = ../secrets/user/patchouli.yaml;
  # sops.secrets.example_key = {};

  user = {
    extraGroups = [ "wheel" "docker" "libvirtd" config.users.groups.keys.name ];
    # Packages here don't have a programs.enable or a custom module.
    # In general, this is more of a "grab bag" of random utils etc.
    home.packages = with pkgs; [
      # Dev
      virt-manager

      # Need some way of bootstrapping rust projects since there's no good flake
      # template for oxalica's overlay.
      rust-analyzer
      rust-bin.stable.latest.default

      zip

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
      nil
      alejandra
      sops
      age

      # Utilities
      mons
      htop
      ripgrep
      sshfs
      tailscale
      fishPlugins.pure
      flameshot
      grim
      oxipng
      fd # Faster find.
      remmina
      yt-dlp
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

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
      #sqlite

      #Games

      # Actual Games
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
      #mangohud
      gamemode
      openal
      portaudio

      # Misc
      anki
      neofetch
      deluge
      nicotine-plus

      # Configure GTK
      configure-gtk

      exactaudiocopy
      openmw-tes3mp
      libsForQt5.qt5.qtwayland
    ];
  };


  # This is all temp stuff so i can migrate.
  home-manager.users.${config.user.name} = {

    fonts.fontconfig.enable = true;

    # Systemd units
    systemd.user.services.sway-session = {
      Unit = {
        Description = "Placeholder for sway startup for other targets";
        After = [ "graphical-session.pre.target" ];
        Wants = [ "graphical-session.pre.target" ];
        BindsTo = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.keepassxc = {
      Unit = {
        Description = "Start KeepassXC on graphical session";
        #After = [ "graphical-session.target" ];
        #PartOf = [ "graphical-session.target" ];
        BindsTo = [ "sway-session.target" ];
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
      Service = { ExecStart = "${pkgs.keepassxc}/bin/keepassxc -platform xcb"; };
    };

    systemd.user.services.slack-autostart = {
      Unit = {
        Description = "Autostart slack on weekdays";
        BindsTo = [ "sway-session.target" ];
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
      Service = { ExecStart = "${../static/maybe_start_slack.sh}"; };
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        WantedBy = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    home.sessionVariables = rec {
      EDITOR = "vim";
      RUST_BACKTRACE = 1;
      #SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      XDG_CACHE_HOME = "~/.cache";
      XDG_CONFIG_HOME = "~/.config";
      XDG_BIN_HOME = "~/.local/bin";
      XDG_DATA_HOME = "~/.local/share";
      # Steam needs this to find Proton-GE
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
      # note: this doesn't replace PATH, it just adds this to it
      PATH = "${XDG_BIN_HOME}";
    };

    # DEV STUFF
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages
        (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
    };

  };
}
