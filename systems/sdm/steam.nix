{ config, pkgs, ... }:
let
  patched-steam = pkgs.steam.override {
    extraPkgs = [
      pkgs.keyutils
      pkgs.libkrb5
      pkgs.ncurses6
    ];
  };
in
{
  patched-steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  # };
}
