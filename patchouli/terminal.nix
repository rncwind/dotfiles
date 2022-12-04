{ config, lib, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
    RUST_BACKTRACE = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
  };

  programs.fish = {
    enable = true;

    loginShellInit = ''
      if test -z $DISPLAY; and test (tty) = "/dev/tty1"
        exec sway
      end
    '';

    interactiveShellInit = ''
      zoxide init fish | source
      direnv hook fish | source
    '';

    shellAliases = {
      ls = "exa";
      ll = "exa -l";
      cat = "bat --paging=never";
      rless = "less -r";
    };

    functions = {
      direnv-flake = {
        body = ''
          if test -e .envrc
            return 0
          else
            echo "use flake" >> .envrc
            direnv allow
          end
        '';
      };

      direnv-nix-shell = {
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

    plugins = [{
      name = "pure";
      src = pkgs.fetchFromGitHub {
        owner = "pure-fish";
        repo = "pure";
        rev = "8c1f69d7f499469979cbecc7b7eaefb97cd6f509";
        sha256 = "ye3fwSepzFaRUlam+eNVmjB6WjhmPcvD+sQ9RkQw164=";
      };
    }];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = { "TERM" = "xterm-256color"; };
      window = {
        padding.x = 10;
        padding.y = 10;
        decorations = "none";
      };
      font = {
        family.normal = "Hasklig";
        family.bold = "Hasklig";
        size = 12.0;
      };
    };
  };

  programs.exa.enable = true;
  programs.bat.enable = true;
}
