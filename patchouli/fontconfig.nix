{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    hasklig
    dejavu_fonts
    open-sans
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (pkgs.nerdfonts.override { fonts = [ "Hasklig" ]; })
  ];
}
