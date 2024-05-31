{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.lang.markups;
in {
  options = {
    modules.dev.lang.markups = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Markup Tooling";
      };
      yaml = mkOption {
        type = types.bool;
        default = false;
        description = "Enable tooling for YAML";
      };
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      []
      ++ (
        if cfg.yaml
        then [pkgs.yaml-language-server]
        else []
      );
  };
}
