{
  config,
  lib,
  pkgs,
  ...
}: let
  inPort = 6881;
in {
  services.deluge = {
    enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [inPort];
    #allowedUDPPorts = [9009 9010 9011 9012 inPort];
    allowedUDPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];
    allowedTCPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];
  };
}
