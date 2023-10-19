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
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."whydoesntmycode.work" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://0.0.0.0:3002";
      };
      locations."/foundry" = {
        proxyPass = "http://0.0.0.0:3003";
        proxyWebsockets = true;
      };
    };
  };
}
