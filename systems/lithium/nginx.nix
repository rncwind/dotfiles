{
  config,
  lib,
  pkgs,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # # Headscale
    # virtualHosts."headscale.whydoesntmycode.work" = {
    #   forceSSL = true;
    #   enableACME = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
    #     proxyWebsockets = true;
    #   };
    # };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@whydoesntmycode.work";
  };
}
