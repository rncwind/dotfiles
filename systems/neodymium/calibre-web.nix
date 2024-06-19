{
  config,
  lib,
  pkgs,
  ...
}: let
  calibreWebPort = 8085;
in {
  services.calibre-web = {
    enable = true;
    group = "pooluser";
    openFirewall = true;
    listen.port = calibreWebPort;
    options = {
      enableBookUploading = true;
    };
  };
  services.nginx.virtualHosts."calibre.home" = {
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString calibreWebPort}";
    };
  };

  users.users.calibre-web.extraGroups = ["pooluser"];
}
