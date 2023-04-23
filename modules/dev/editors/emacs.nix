{ config, lib, pkgs, modules, ... }:

with lib; let
  cfg = config.modules.dev.editors.emacs;
  eScript = pkgs.writeScriptBin "e" ''
    #! ${pkgs.bash}/bin/bash
    emacsclient -n -r $@
  '';
  eScriptNew = pkgs.writeScriptBin "enew" ''
    #! ${pkgs.bash}/bin/bash
    emacsclient -n -c $@
  '';
in
{
  options = {
    modules.dev.editors.emacs.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable emacs";
    };

    modules.dev.editors.emacs.daemon = mkOption {
      type = types.bool;
      default = true;
      description = "Enable emacs in daemon mode";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs; [ ] ++
      (if cfg.daemon then [ eScript eScriptNew ] else [ ]);

    home-manager.users.${config.user.name} = {
      programs.emacs = {
        enable = cfg.enable;
        package = pkgs.emacsPgtk;
        extraPackages = (epkgs: [ epkgs.vterm ]);
      };

      services.emacs = mkIf cfg.daemon {
        enable = cfg.daemon;
        package = pkgs.emacsPgtk;
      };
    };
  };
}
