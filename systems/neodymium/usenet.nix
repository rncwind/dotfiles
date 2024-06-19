{
  config,
  lib,
  pkgs,
  inputs,
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
      UMask = 001;
      BindPaths = [
        "/mnt/nas-pool/media/rtorrent"
        "/mnt/nas-pool/media/"
      ];
    };
  };
  users.users.sabnzbd.extraGroups = ["pooluser"];
  services.nginx.virtualHosts."sabnzbd.home" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString sabnzbdPort}";
    };
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.nginx.virtualHosts."prowlarr.home" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString prowlarrPort}";
    };
  };

  services.radarr = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
  };
  services.nginx.virtualHosts."radarr.home" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString radarrPort}";
    };
  };

  services.sonarr = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
  };
  services.nginx.virtualHosts."sonarr.home" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString sonarrPort}";
    };
  };

  services.bazarr = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
  };
  services.nginx.virtualHosts."bazarr.home" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString bazarrPort}";
    };
  };
}
