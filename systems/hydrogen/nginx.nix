{ config, lib, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."hydrogen.local" = {
      serverName = "hydrogen.local";
      locations."/" = {
        proxyPass = "http://0.0.0.0:9001";
        proxyWebsockets = true;
      };
    };

    virtualHosts."adguard.local" = {
      serverName = "adguard.local";
      locations."/" = {
        proxyPass = "http://0.0.0.0:3000";
        proxyWebsockets = true;
      };
    };

    virtualHosts.${config.services.grafana.settings.server.domain} = {
      serverName = config.services.grafana.settings.server.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };

    virtualHosts."prometheus.local" = {
      serverName = "prometheus.local";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
        proxyWebsockets = true;
      };
    };
  };

}
