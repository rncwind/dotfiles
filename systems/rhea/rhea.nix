{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-substituters = [ "https://cache.nixos.org" "https://cache.garnix.io" ];
    trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    trusted-users = [ "root" "rhea" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    gcc
    unzip
  ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "rhea";
  networking.domain = "vps.ovh.net";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 8080 ];
  };
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"
  ];

  # Now drop into our module config.
  modules = {
    user = {
      name = "rhea";
      description = "Web Server";
      homeDir = "/home/rhea";
      extraGroups = [ "wheel" ];
    };

    dekstop = {
      desktop-utils.enable = false;
      fontconfig.enable = false;
      music.enable = false;
      sway.enable = false;
    };

    dev = {
      editors.emacs.enable = false;
      dev-tools.enable = false;
      python.enable = false;
    };

    shell = {
      alacritty.enable = false;
      fish.enable = false;
      terminalPrograms.enable = false;
    };
  };

  system.stateVersion = "22.11";
}
