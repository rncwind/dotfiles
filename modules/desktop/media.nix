{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib;
with types; let
  cfg = config.modules.desktop.media;
in {
  options.modules.desktop.media = {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Enable media viewers";
    };

    rss = mkOption {
      type = bool;
      default = false;
      description = "Enable RSS tools";
    };

    documents = mkOption {
      type = bool;
      default = false;
      description = "Enable Document viewing tools";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      [mpv zathura okular]
      ++ (
        if cfg.rss
        then [fluent-reader]
        else []
      )
      ++ (
        if cfg.documents
        then [zathura okular libreoffice pandoc]
        else []
      );
  };
}
