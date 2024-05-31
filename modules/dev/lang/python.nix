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
    modules.dev.lang.python = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable python tooling";
      };

      lsp = mkOption {
        type = types.bool;
        default = false;
        description = "Enable pylsp and it's plugins";
      };

      pyright = mkOption {
        type = types.bool;
        default = false;
        description = "enable pyright";
      };

      black = mkOption {
        type = types.bool;
        default = false;
        description = "enable black formatter";
      };

      isort = mkOption {
        type = types.bool;
        default = false;
        description = "enable isort to sort python imports";
      };
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
        if cfg.lsp
        then [
          pkgs.python311Packages.python-lsp-server
          pkgs.python311Packages.python-lsp-ruff
          pkgs.python311Packages.pylsp-mypy
          pkgs.python311Packages.pyls-isort
          pkgs.python311Packages.pyls-flake8
        ]
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
