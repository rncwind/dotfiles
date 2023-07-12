{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.types; let
  cfg = config.modules.dev.web;
in {
  options = {
    modules.dev.web.enable = mkOption {
      type = bool;
      default = false;
      description = "Enable web dev tools";
    };

    # modules.dev.web.ts-ls = mkOption {
    #   type = bool;
    #   default = false;
    #   description = "Enable typescript language server";
    # };

    modules.dev.web.node18 = mkOption {
      type = bool;
      default = false;
      description = "Install and enable NPM";
    };

    modules.dev.web.yarn = mkOption {
      type = bool;
      default = false;
      description = "Install and Enable Yarn";
    };

    modules.dev.web.linters = mkOption {
      type = bool;
      default = false;
      description = "Enable linters. Eslint and stylelint";
    };

    modules.dev.web.formatters = mkOption {
      type = bool;
      default = false;
      description = "Enable formatters. Tidy and js-beautify";
    };

    modules.dev.web.postman = mkOption {
      type = bool;
      default = false;
      description = "Enable postman";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages =
      []
      ++ (
        if cfg.node18
        then [pkgs.nodejs_18]
        else []
      )
      ++ (
        if cfg.yarn
        then [pkgs.yarn pkgs.yarn2nix]
        else []
      )
      ++ (
        if cfg.linters
        then [pkgs.nodePackages_latest.eslint pkgs.nodePackages.stylelint]
        else []
      )
      ++ (
        if cfg.formatters
        then [pkgs.html-tidy pkgs.nodePackages.js-beautify]
        else []
      )
      ++ (
        if cfg.postman
        then [pkgs.postman]
        else []
      );
  };
}
