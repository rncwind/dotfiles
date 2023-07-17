{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  patched-discord = pkgs.discord-ptb.override {nss = pkgs.nss_latest;};
  ffxiv-wrapper = pkgs.writeScriptBin "ffxiv" ''
    #! ${pkgs.bash}/bin/bash
    export DXVK_FRAME_RATE=74
    exec gamemoderun XIVLauncher.Core "$@"
  '';
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
in {
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
        music = {
          enable = true;
          enableMpdScribble = true;
        };
        production = {
          enable = true;
          reaper = true;
        };
      };
      fontconfig = {
        enable = true;
        nerdFontsList = ["Hasklig"];
        cjk = true;
        emoji = true;
        noto = true;
      };
      i18n = {
        enable = true;
        useMozc = true;
      };
    };

    dev = {
      dev-tools = {
        enable = true;
        git = true;
        cloudTools = true;
        tldr = true;
        shellDev = true;
        grpc = true;
        grabBag = true;
        virt = true;
        linkers = false;
        asciinema = true;
        reversing = true;
      };


      lang = {
        web = {
          enable = true;
          node18 = true;
          yarn = false;
          formatters = true;
          linters = true;
        };
        haskell = {
          enable = true;
          buildTools = true;
          hls = true;
          hoogle = true;
        };
        rust = {
          enable = true;
          rust-analyzer = true;
          rust-stable = true;
        };
      };
    };

    secrets = {
      enable = true;
      #expose = ["example_key"];
      expose = {
        lastfm_username = {owner = config.users.users.patchouli.name;};
        lastfm_password = {owner = config.users.users.patchouli.name;};
        librefm_username= {owner = config.users.users.patchouli.name;};
        librefm_password = {owner = config.users.users.patchouli.name;};
        # example_key = {owner = config.users.users.patchouli.name;};
        # another_example = {};
      };
      keyFilePath = "/home/patchouli/.config/sops/age/keys.txt";
      secretsFile = ../secrets/users/patchouli.yaml;
    };
  };

  # sops.age.keyFile = "/home/patchouli/.config/sops/age/keys.txt";
  # sops.defaultSopsFile = ../secrets/user/patchouli.yaml;
  # sops.secrets.example_key = {};

  user = {
    extraGroups = ["wheel" "docker" config.users.groups.keys.name];
    # Packages here don't have a programs.enable or a custom module.
    # In general, this is more of a "grab bag" of random utils etc.
    home.packages = with pkgs; [
      # Dev
      virt-manager
      zip

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
      glib
      dracula-theme

      # Communication
      patched-discord
      slack

      # Audio and Music
      pavucontrol
      spotify
      picard
      soundkonverter
      chromaprint
      rsgain

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
      yt-dlp
      (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))

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
      neofetch
      deluge
      nicotine-plus

      # Configure GTK
      configure-gtk

      exactaudiocopy
      libsForQt5.qt5.qtwayland

      # TODO: SORT THESE
      obs-studio
      appimage-run
      coreutils-full
      sudo
      which
      asciinema
      asciinema-agg
      chromium
      wireshark
      libnotify
      anki-bin
      pkg-config
      gimp
    ];
  };

  # This is all temp stuff so i can migrate.
  home-manager.users.${config.user.name} = {
    fonts.fontconfig.enable = true;

    # Systemd units
    systemd.user.services.sway-session = {
      Unit = {
        Description = "Placeholder for sway startup for other targets";
        After = ["graphical-session.pre.target"];
        Wants = ["graphical-session.pre.target"];
        BindsTo = ["graphical-session.target"];
      };
    };

    systemd.user.services.keepassxc = {
      Unit = {
        Description = "Start KeepassXC on graphical session";
        #After = [ "graphical-session.target" ];
        #PartOf = [ "graphical-session.target" ];
        BindsTo = ["sway-session.target"];
      };
      Install = {WantedBy = ["sway-session.target"];};
      Service = {ExecStart = "${pkgs.keepassxc}/bin/keepassxc -platform xcb";};
    };

    systemd.user.services.slack-autostart = {
      Unit = {
        Description = "Autostart slack on weekdays";
        BindsTo = ["sway-session.target"];
      };
      Install = {WantedBy = ["sway-session.target"];};
      Service = {ExecStart = "${../static/maybe_start_slack.sh}";};
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = ["graphical-session.target"];
        WantedBy = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Install = {WantedBy = ["sway-session.target"];};
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
      # XDG_CURRENT_DESKTOP = "sway";
      # XDG_SESSION_DESKTOP = "sway";
      # XDG_CACHE_HOME = "~/.cache";
      # XDG_CONFIG_HOME = "~/.config";
      # XDG_BIN_HOME = "~/.local/bin";
      # XDG_DATA_HOME = "~/.local/share";
      # Steam needs this to find Proton-GE
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    };

    # DEV STUFF
    programs.vscode = {
      enable = true;
      package =
        pkgs.vscode.fhsWithPackages
        (ps: with ps; [rustup zlib openssl.dev pkg-config python310Full]);
    };
  };
}