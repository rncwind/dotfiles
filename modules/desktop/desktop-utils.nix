{ config, lib, pkgs, modules, ... }:

with lib; with types; let
  cfg = config.modules.desktop.desktop-utils;
in
{
  options = {
    modules.desktop.desktop-utils.enable = mkOption {
      type = bool;
      default = true;
      description = "Enable desktop utilities";
    };

    modules.desktop.desktop-utils.enableMako = mkOption {
      type = bool;
      default = true;
      description = "Enable mako";
    };

    modules.desktop.desktop-utils.enableGammastep = mkOption {
      type = bool;
      default = true;
      description = "Enable flux for wayland";
    };
  };

  config = mkIf (cfg.enable && config.user.home-manager.enable) {
    home-manager.users.${config.user.name} = {

      services.mako = mkIf cfg.enableMako {
        enable = cfg.enableMako;
        defaultTimeout = 10000;
        ignoreTimeout = true;
        font = "hasklig 10";
      };

      services.gammastep = mkIf cfg.enableGammastep {
        enable = cfg.enableGammastep;
        temperature = {
          day = 6500;
          night = 2700;
        };
        tray = true;
        latitude = 51.5072;
        longitude = 0.12;
      };
    };
  };
}
