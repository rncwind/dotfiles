{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib;
with types; let
  cfg = config.modules.desktop.fontconfig;
in {
  options = {
    modules.desktop.fontconfig.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the minimal set of fonts";
    };

    modules.desktop.fontconfig.nerdFontsList = mkOption {
      #default = [ "Hasklig" ];
      default = [];
      description = "List of nerdfonts to patch. Default is hasklig";
    };

    modules.desktop.fontconfig.cjk = mkOption {
      default = false;
      description = "Enable CJK Fonts";
    };

    modules.desktop.fontconfig.emoji = mkOption {
      default = false;
      description = "✅🤣❓";
    };

    modules.desktop.fontconfig.noto = mkOption {
      default = false;
      description = "Enable the large, but almost complete noto fontset";
    };
  };

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs;
      [dejavu_fonts liberation_ttf open-sans hasklig
       # Annoyingly required.
       (pkgs.nerdfonts.override {fonts = cfg.nerdFontsList;})]
      ++ (
        if cfg.cjk
        then [noto-fonts-cjk]
        else []
      )
      ++ (
        if cfg.emoji
        then [noto-fonts-emoji]
        else []
      )
      ++ (
        if cfg.noto
        then [noto-fonts]
        else []
      );
  };

}
