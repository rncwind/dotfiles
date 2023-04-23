{ config, lib, pkgs, modules, ... }:

with lib; with types; let
  cfg = config.modules.desktop.fontconfig;
in
{
  options = {
    modules.desktop.fontconfig.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the usual set of fonts";
    };


    modules.desktop.fontconfig.nerdFontsList = mkOption {
      default = [ "Hasklig" ];
      description = "List of nerdfonts to patch. Default is hasklig";
    };
  };

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs; [
      hasklig
      dejavu_fonts
      open-sans
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      (pkgs.nerdfonts.override { fonts = cfg.nerdFontsList; })
    ];
  };
}
