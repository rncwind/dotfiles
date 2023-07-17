{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  patched-discord = pkgs.discord-ptb.override {nss = pkgs.nss_latest;};
in {
  user = {
    name = "satori";
    description = "Here's where it really begins. Now, sleep with this trauma that will leave you sleepless!";
    homeDir = "/home/satori";
    stateVersion = "23.05";
    extraGroups = ["wheel" "docker" "networkmanager" config.users.groups.keys.name];

    home.packages = with pkgs; [
      deploy-rs
    ];
  };

}
