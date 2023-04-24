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
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"
  ];


  user = {
    name = "rhea";
    description = "A web hoster";
    homeDir = "/home/rhea";
    extraGroups = [ "wheel" ];
  };

  modules = {
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
    desktop = {
      desktop-utils.enable = false;
      fontconfig.enable = false;
      audio.music.enable = false;
      sway.enable = false;
    };
  };

  # ACME settings.
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@whydoesntmycode.work";


  # Set up a reverse proxy that binds to a unix socket.
  services.nginx = {
    enable = true;
    virtualHosts."whydoesntmycode.work" = {
      # Force enable ACME and TLS.
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://unix:/tmp/socket";
        proxyWebsockets = true;
      };
    };
  };
  # Let it read tmp
  systemd.services.nginx.serviceConfig = {
    PrivateTmp = lib.mkForce false;
  };


  # # Enable nginx
  # services.nginx.enable = true;
  # # Configure our host
  # services.nginx.virtualHosts."whydoesntmycode.work" = {
  #   # Force enable ACME and TLS.
  #   forceSSL = true;
  #   enableACME = true;
  #   locations."/" = {
  #     proxyPass = "http://unix:/tmp/socket";
  #     proxyWebsockets = true;
  #   };
  # };


  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  # Now drop into our module config.
  system.stateVersion = "22.11";
}
