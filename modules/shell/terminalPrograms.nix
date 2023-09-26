{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
# This is where we put sundry terminal applications that we often want.
# Good examples of this include zoxide and direnv!
with lib; let
  cfg = config.modules.shell.terminalPrograms;
in {
  options = {
    modules.shell.terminalPrograms.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable various terminal applications that we often find useful";
    };

    modules.shell.terminalPrograms.enableZoxide = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zoxide";
    };

    modules.shell.terminalPrograms.enableExa = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Zoxide for faster jumping";
    };

    modules.shell.terminalPrograms.enableBat = mkOption {
      type = types.bool;
      default = true;
      description = "Enable bat, a cat replacement with wings";
    };

    modules.shell.terminalPrograms.enableDirenv = mkOption {
      type = types.bool;
      default = true;
      description = "Enable direnv, the saving grace of nixos";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.bat.enable = cfg.enableBat;
      programs.eza.enable = cfg.enableExa;

      programs.zoxide = mkIf cfg.enableZoxide {
        enable = cfg.enableZoxide;
        # If we are using fish, we want to enable zoxide's integration.
        enableFishIntegration = config.modules.shell.fish.enable;
      };

      programs.direnv = mkIf cfg.enableDirenv {
        enable = cfg.enableDirenv;
        nix-direnv.enable = true;
      };
    };
  };
}
