{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-main,
  ...
}: let
  prowlarrPort = 9696;
  sonarrPort = 8989;
  radarrPort = 7878;
  bazarrPort = 6767;
  sabnzbdPort = 8081;
in {
  services.sabnzbd = {
    enable = true;
    group = "pooluser";
    package = nixpkgs-main.sabnzbd;
  };

  systemd.services.sabnzbd = {
    serviceConfig = {
      # We need to do all of this, or else it wont be able to read outside
      # of it's home dir, which is not very useful for us as ZFS users.
      LockPersonality = lib.mkForce false;
      NoNewPrivileges = lib.mkForce false;
      PrivateDevices = lib.mkForce false;
      PrivateMounts = lib.mkForce false;
      PrivateUsers = lib.mkForce false;
      UMask = 011;
      BindPaths = [
        "/mnt/nas-pool/media/rtorrent"
        "/mnt/nas-pool/media/"
      ];
    };
  };
  users.users.sabnzbd.extraGroups = ["pooluser"];
  services.nginx.virtualHosts."sabnzbd.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString sabnzbdPort}";
    };
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.nginx.virtualHosts."prowlarr.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString prowlarrPort}";
    };
  };

  services.radarr = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
  };
  services.nginx.virtualHosts."radarr.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString radarrPort}";
    };
  };

  services.sonarr = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
  };
  services.nginx.virtualHosts."sonarr.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString sonarrPort}";
    };
  };

  services.bazarr = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
  };
  services.nginx.virtualHosts."bazarr.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString bazarrPort}";
    };
  };
}
