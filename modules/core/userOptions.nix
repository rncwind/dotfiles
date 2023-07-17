{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
with lib; let
  cfg = config.user;
in {
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
      default = [];
    };

    # Home manager stuff. This is mostly used so we can install non-moduled
    # pacakges and similar.
    home = {
      packages = mkOption {
        type = listOf package;
        default = [];
      };
    };

    home-manager.enable = mkOption {
      type = bool;
      default = true;
    };

    stateVersion = mkOption {
      default = "22.05";
    };
  };

  # This is the actual reificiation of our options. Everyting delcared here
  # is actually used and included in the config.
  config = {
    users.mutableUsers = true;
    users.users = {
      "${cfg.name}" = {
        description = cfg.description;
        home = cfg.homeDir;
        isNormalUser = true;
        extraGroups = cfg.extraGroups;
      };
    };

    home-manager = mkIf cfg.home-manager.enable {
      useGlobalPkgs = mkDefault true;
      useUserPackages = mkDefault true;
      users."${cfg.name}" = {
        home = with cfg.home; {
          inherit packages;

          stateVersion = cfg.stateVersion;
          homeDirectory = cfg.homeDir;
          username = cfg.name;
        };
        programs.home-manager.enable = true;
      };
    };
  };
}
