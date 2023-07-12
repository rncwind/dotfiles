{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with types; let
  cfg = config.modules.desktop.i18n;
  fcitx5Package = pkgs.fcitx5-with-addons.override { addons = with pkgs; [ fcitx5-mozc ]; };
in {
  options = {
    modules.desktop.i18n.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable i18n options";
    };

    modules.desktop.i18n.useAnthy = mkOption {
      type = bool;
      default = false;
      description = "Use anthy";
    };

    modules.desktop.i18n.useMozc = mkOption {
      type = bool;
      default = false;
      description = "Use mozc";
    };
  };

  config = mkIf cfg.enable {

    home-manager.users.${config.user.name} = {
      i18n.inputMethod = {
        package = fcitx5Package;
        enabled = "fcitx5";
        fcitx5.addons = ([]
          ++ (
            if cfg.useAnthy
            then [pkgs.fcitx5-anthy]
            else []
          )
          ++ (
            if cfg.useMozc
            then [pkgs.fcitx5-mozc]
            else []
          )
        );
      };
    systemd.user.services.fcitx5-daemon = {
      Service = {
      ExecStart = "${fcitx5Package}/bin/fcitx5";
      };
    };
  };
  };
}
