{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib; let
  cfg = config.modules.dev.lang.python;
in {
  options = {
    modules.dev.python.enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable python tooling";
    };

    modules.dev.python.pyright = mkOption {
      type = types.bool;
      default = true;
      description = "enable pyright LSP";
    };

    modules.dev.python.black = mkOption {
      type = types.bool;
      default = true;
      description = "enable black formatter";
    };

    modules.dev.python.isort = mkOption {
      type = types.bool;
      default = true;
      description = "enable isort to sort python imports";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages =
      [pkgs.poetry]
      ++ (
        if cfg.pyright
        then [pkgs.pyright]
        else []
      )
      ++ (
        if cfg.black
        then [pkgs.black]
        else []
      )
      ++ (
        if cfg.isort
        then [pkgs.isort]
        else []
      );
  };
}
