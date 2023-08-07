{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib;
with types; let
  cfg = config.modules.shell.alacritty;
in {
  options = {
    modules.shell.alacritty = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Alacritty as graphical shell";
      };

      font = mkOption {
        type = types.str;
        default = "Hasklig";
        description = "Font family alacritty uses.";
      };

      fontSize = mkOption {
        type = types.number;
        default = 12.0;
        description = "Font size";
      };

      windowPadding = mkOption {
        type = attrsOf number;
        default = {
          x = 10;
          y = 10;
        };
        description = "Window padding";
      };

      windowDecorations = mkOption {
        type = types.str;
        default = "none";
        description = "Window decorations";
      };
    };
  };

  # If alacritty is enabled then
  config = mkIf cfg.enable {
    # Enable it.
    #programs.alacritty.enable = mkIf cfg.enable true;

    home-manager.users.${config.user.name} = {
      programs.alacritty = {
        enable = true;

        settings = {
          env = {"TERM" = "xterm-256color";};

          font = {
            family.normal = cfg.font;
            family.bold = cfg.font;
            size = cfg.fontSize;
          };

          window = {
            padding.x = cfg.windowPadding.x;
            padding.y = cfg.windowPadding.y;
            decorations = cfg.windowDecorations;
          };
        };
      };
    };
  };
}
