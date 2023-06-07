{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib; let
  cfg = config.modules.dev.dev-tools;
in {
  options = {
    modules.dev.dev-tools.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dev tools for this machine.";
    };

    modules.dev.dev-tools.git = mkOption {
      type = types.bool;
      default = false;
      description = "Enable git and git tools";
    };

    modules.dev.dev-tools.webTools = mkOption {
      type = types.bool;
      default = false;
      description = "Enable web tools like curl, postman etc";
    };

    modules.dev.dev-tools.cloudTools = mkOption {
      type = types.bool;
      default = false;
      description = "Enable cloud tools like k9s, kubectl etc";
    };

    modules.dev.dev-tools.tldr = mkOption {
      type = types.bool;
      default = false;
      description = "Enable tldr, man pages for the lazy";
    };

    modules.dev.dev-tools.shellDev = mkOption {
      type = types.bool;
      default = false;
      description = "Enable bash language server, shellcheck and bashdb";
    };

    modules.dev.dev-tools.grabBag = mkOption {
      type = types.bool;
      default = false;
      description = "Various tools that don't fit anywhere else. Stuff like jq";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      [codeship-jet fzf just sqlite]
      ++ (
        if cfg.git
        then [git git-crypt gnupg tig]
        else []
      )
      ++ (
        if cfg.webTools
        then [curl postman]
        else []
      )
      ++ (
        if cfg.cloudTools
        then [kubectl cloud-sql-proxy k9s]
        else []
      )
      ++ (
        if cfg.grabBag
        then [jq]
        else []
      )
      ++ (
        if cfg.shellDev
        then [nodePackages_latest.bash-language-server shellcheck bashdb]
        else []
      );

    home-manager.users.${config.user.name} = {
      programs.tealdeer = mkIf cfg.tldr {
        enable = cfg.tldr;
        settings = {
          display = {
            use_pager = true;
          };
          updates = {
            auto_update = true;
          };
        };
      };
    };
  };
}
