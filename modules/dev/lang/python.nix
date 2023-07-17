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
    modules.dev.lang.python.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable python tooling";
    };

    modules.dev.lang.python.pyright = mkOption {
      type = types.bool;
      default = false;
      description = "enable pyright LSP";
    };

    modules.dev.lang.python.black = mkOption {
      type = types.bool;
      default = false;
      description = "enable black formatter";
    };

    modules.dev.lang.python.isort = mkOption {
      type = types.bool;
      default = false;
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
