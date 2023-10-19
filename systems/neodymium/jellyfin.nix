{ config, lib, pkgs, ... }:
let
  jellyfinPort = 8096;
in {
  services.jellyfin = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
  };
  users.users.jellyfin.extraGroups = [ "pooluser" ];
  services.nginx.virtualHosts."jellyfin.local" = {
    locations."/" = {
      proxyPass = "http://0.0.0.0:${builtins.toString jellyfinPort}";
    };
  };
}
