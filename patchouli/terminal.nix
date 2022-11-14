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

    interactiveShellInit = ''
      zoxide init fish | source
      direnv hook fish | source
    '';

    functions = {
      nix-shell = ''set -l nix_shell_info (
  if test -n "$IN_NIX_SHELL"
    echo -n "<nix-shell> "
  end
)'';
    };

    shellAliases = {
      ls = "exa";
      ll = "exa -l";
      cat = "bat --paging=never";
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
