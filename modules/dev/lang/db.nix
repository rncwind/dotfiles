{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib; let
  cfg = config.modules.dev.lang.db;
in {
  options = {
    modules.dev.lang.db = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable db tooling";
      };
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs; [jetbrains.datagrip dbeaver-bin];
  };
}
