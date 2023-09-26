{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib; let
  cfg = config.modules.desktop.audio.production;
in {
  options.modules.desktop.audio.production = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Audio Production tools";
    };

    reaper = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Reaper";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages =
      []
      ++ (
        if cfg.reaper
        then [pkgs.reaper]
        else []
      );
  };
}
