{ config, lib, pkgs, modules, ... }:

with lib; let
  cfg = config.modules.desktop.audio.music;
in
{
  options = {
    modules.desktop.audio.music.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the music module. Mostly contains music players";
    };

    modules.desktop.audio.music.enableNcmpcpp = mkOption {
      type = types.bool;
      default = true;
      description = "Enable ncmpcpp for this device";
    };

    modules.desktop.audio.music.enableNcspot = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ncspot, a ncurses spotify interface";
    };
  };

  config = mkIf cfg.enable {

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
