{
  config,
  lib,
  pkgs,
  ...
}: let
  transmissionPort = 9091;
in {
  services.transmission = {
    package = pkgs.transmission_4;
    enable = true;
    group = "pooluser";
    downloadDirPermissions = "775";
    openPeerPorts = true;
    openRPCPort = true;
    extraFlags = [
      "--log-level=debug"
    ];

    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      encryption = 2;
      incomplete-dir-enabled = false;
      download-dir = "/mnt/nas-pool/media/rtorrent/default";
    };
  };

  systemd.services.transmission = {
    serviceConfig = {
      # We need to do all of this, or else it wont be able to read outside
      # of it's home dir, which is not very useful for us as ZFS users.
      LockPersonality = lib.mkForce false;
      NoNewPrivileges = lib.mkForce false;
      PrivateDevices = lib.mkForce false;
      PrivateMounts = lib.mkForce false;
      PrivateUsers = lib.mkForce false;
      BindPaths = [
        "/mnt/nas-pool/media/rtorrent"
        "/mnt/nas-pool/media/"
      ];
    };
  };
  users.users.transmission.extraGroups = ["pooluser"];

  services.nginx.virtualHosts."transmission.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString transmissionPort}";
    };
  };
}
