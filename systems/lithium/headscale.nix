{
  config,
  lib,
  pkgs,
  ...
}: let
  basedomain = "whydoesntmycode.work";
  domain = "headscale.${basedomain}";
in {
  services.headscale = {
    enable = true;
    port = 8080;
    address = "0.0.0.0";
    settings = {
      serverUrl = "https://${domain}:8080";
      logtail.enabled = false;
      dns_config = {
        magic_dns = true;
        nameservers = ["1.1.1.1"];
        domains = ["headscale.whydoesntmycode.work"];
        baseDomain = basedomain;
      };
    };
  };

  environment.systemPackages = [config.services.headscale.package];

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port 41641 3478];
    allowedTCPPorts = [80 443 8080];
  };
}
