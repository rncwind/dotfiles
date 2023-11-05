{
  config,
  lib,
  pkgs,
  ...
}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@whydoesntmycode.work";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = false;
    recommendedTlsSettings = true;
    virtualHosts."whydoesntmycode.work" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://unix:/srv/blog/socket";
      };
      locations."/shared" = {
        root = "/var/www/";
      };
    };
  };
}
