{ config, lib, pkgs, modules, ... }:

with lib; let
  cfg = config.modules.dev.dev-tools;
in
{
  options = {
    modules.dev.dev-tools.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable dev tools for this machine.";
    };

    modules.dev.dev-tools.git = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git and git tools";
    };

    modules.dev.dev-tools.webTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable web tools like curl, postman etc";
    };

    modules.dev.dev-tools.cloudTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable cloud tools like k9s, kubectl etc";
    };

    modules.dev.dev-tools.tldr = mkOption {
      type = types.bool;
      default = true;
      description = "Enable tldr, man pages for the lazy";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs; [ codeship-jet fzf just sqlite ]
      ++ (if cfg.git then [ git git-crypt gnupg tig ] else [ ])
      ++ (if cfg.webTools then [ curl postman ] else [ ])
      ++ (if cfg.cloudTools then [ kubectl cloud-sql-proxy k9s ] else [ ]);

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
