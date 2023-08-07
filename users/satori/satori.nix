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
      tailscale
      patched-discord
      sqlite
      rofi
      firefox
      slack
      keepassxc
    ];
  };

  modules = {
    shell = {
      fish.enable = true;
      alacritty.enable = true;
      terminalPrograms.enable = true;
    };

    dev = {
      dev-tools = {
        enable = true;
        git = true;
        grabBag = true;
      };
    };

    desktop = {
      hyprland.enable = true;
      waybar = {
        enable = true;
        hyprland = true;
      };
      desktop-utils = {
        enable = true;
        enableMako = true;
        enableGammastep = true;
      };
    };
  };
  # programs.hyprland = {
  #   enable = true;
  # };


  home-manager.users.${config.user.name} = {
  };
}
