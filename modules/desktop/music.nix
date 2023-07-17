{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib; let
  cfg = config.modules.desktop.audio.music;
in {
  options.modules.desktop.audio.music = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the music module. Mostly contains music players";
    };

    enableNcmpcpp = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ncmpcpp for this device";
    };

    enableNcspot = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ncspot, a ncurses spotify interface";
    };

    enableMpdScribble = mkOption {
      type = types.bool;
      default = false;
      description = "Enable mpdscribble. A lastfm scrobbler for mpd";
    };
  };

  config = mkIf cfg.enable {

    # FIXME: We want evaltime secrets before we can do this properly.
    # services.mpdscribble = mkIf cfg.enableMpdScribble {
    #   enable = cfg.enableMpdScribble;
    #   endpoints = {
    #     "last.fm" = {
    #       passwordFile = config.sops.secrets.lastfm_password.path;
    #     };
    #   };
    # };

    home-manager.users.${config.user.name} = {
      programs.ncmpcpp = mkIf cfg.enableNcmpcpp {
        enable = cfg.enableNcmpcpp;
        settings = {
          # The default user interface is just bad. Use the alt one.
          user_interface = "alternative";
          # Change sorting rules to sort by album artist, not artist.
          media_library_primary_tag = "album_artist";
        };
      };

      programs.ncspot = mkIf cfg.enableNcspot {
        enable = cfg.enableNcspot;
        settings = {
          use_nerdfont = true;
          volnorm = true;
          bitrate = 320;
        };
      };

    };
  };
}
