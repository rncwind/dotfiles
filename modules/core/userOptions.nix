{ config, lib, pkgs, inputs, options, ... }:
with lib; let
  cfg = config.user;
in
{
  options.user = with types; {
    name = mkOption {
      type = str;
      default = "patchouli";
    };

    description = mkOption {
      type = str;
      default = "She may be gloomy, but she listens to hip hop and stuff";
    };

    homeDir = mkOption {
      type = str;
      default = "/home/patchouli";
    };

    extraGroups = mkOption {
      type = listOf str;
      default = [ ];
    };

    # Home manager stuff. This is mostly used so we can install non-moduled
    # pacakges and similar.
    home = {
      packages = mkOption {
        type = listOf package;
        default = [ ];
      };

      home-manager.enable = mkOption {
        type = bool;
        default = true;
      };
    };
  };

  config = {
    # Reify our user configuration options.
    users.mutableUsers = true;
    users.users = {
      "${cfg.name}" = {
        description = cfg.description;
        home = cfg.homeDir;
        isNormalUser = true;
        extraGroups = cfg.extraGroups;
      };
    };
  };
}
