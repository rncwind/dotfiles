{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with types; let
  cfg = config.modules.desktop.hyprland;
in {
  options = {
    modules.desktop.hyprland.enable = mkOption {
      type = types.bool;
      default = false;
    };

    modules.desktop.hyprland.xwayland = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable && config.user.home-manager.enable) {
    home-manager.users.${config.user.name} = {
      imports = [
        inputs.hyprland.homeManagerModules.default
      ];

      wayland.windowManager.hyprland = {
        enable = cfg.enable;
        xwayland.enable = cfg.xwayland;
        extraConfig = import ./hyprland-extra-config.nix {};
      };
    };
  };
}
