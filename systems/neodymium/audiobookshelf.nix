{
  config,
  lib,
  pkgs,
  ...
}: let
  audiobookshelfPort = 8008;
in {
  services.audiobookshelf = {
    enable = true;
    port = 8008;
    host = "0.0.0.0";
    group = "pooluser";
  };
  users.users.audiobookshelf.extraGroups = ["pooluser"];

  systemd.services.audiobookshelf = {
    serviceConfig = {
      PrivateMounts = lib.mkForce false;
      PrivateUsers = lib.mkForce false;
      UMask = 001;
      BindPaths = [
        "/mnt/nas-pool/media/media/audiobooks"
        "/mnt/nas-pool/media/media/podcasts"
      ];
    };
  };

  services.nginx.virtualHosts."audiobookshelf.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString audiobookshelfPort}";
      proxyWebsockets = true;
    };
  };
}
