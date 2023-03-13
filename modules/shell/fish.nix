{ config, lib, pkgs, modules, ... }:

with lib; let
  cfg = config.modules.shell.fish;
in
{
  options = {
    modules.shell.fish.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the Friendly Interactive Shell";
    };

    modules.shell.fish.enableInitScripts = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shell init scripts";
    };

    modules.shell.fish.enableAliases = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shell aliases";
    };

    modules.shell.fish.enableNixFunctions = mkOption {
      type = types.bool;
      default = true;
      description = "Enable nix direnv helper functions";
    };

    modules.shell.fish.enablePure = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the pure modeline";
    };
  };

  # If fish is enabled
  config = mkIf cfg.enable {
    programs.fish.enable = mkIf cfg.enable true;

    home-manager.users.${config.user.name} = {
      programs.fish = {
        enable = true;

        loginShellInit = mkIf cfg.enableInitScripts ''
          if test -z $DISPLAY; and test (tty) = "/dev/tty1"
            exec sway
          end
        '';

        interactiveShellInit = mkIf cfg.enableInitScripts ''
          zoxide init fish | source
          direnv hook fish | source
        '';

        shellAliases = mkIf cfg.enableAliases {
          ls = "exa";
          ll = "exa -l";
          cat = "bat --paging=never";
          normalcat = "cat";
          rless = "less -r";
        };

        functions = {
          direnvUseFlake = mkIf cfg.enableNixFunctions {
            body = ''
              if test -e .envrc
                return 0
              else
                echo "use flake" >> .envrc
                direnv allow
              end
            '';
          };

          direnvUseNixShell = mkIf cfg.enableNixFunctions {
            argumentNames = "filename";
            body = ''
              if test -e .envrc
                return 0
              else
                if test -n "$filename"
                  echo "use nix $filename" >> .envrc
                else
                  echo "use nix" >> .envrc
                end
                direnv allow
              end
            '';
          };
        };
        plugins = mkIf cfg.enablePure [{
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "pure-fish";
            repo = "pure";
            rev = "8c1f69d7f499469979cbecc7b7eaefb97cd6f509";
            sha256 = "ye3fwSepzFaRUlam+eNVmjB6WjhmPcvD+sQ9RkQw164=";
          };
        }];
      };
    };
  };
}
