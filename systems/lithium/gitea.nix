{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.postgresql = {
    enable = true;
    authentication = ''
      local gitea all ident map=gitea-users
    '';
    identMap = ''
      gitea-users gitea gitea
    '';
  };

  services.forgejo = {
    enable = true;
    database = {
      type = "postgres";
      passwordFile = config.sops.secrets."gitea/postgresDBPass".path;
    };
    settings = {
      DEFAULT.APP_NAME = "Why Doesn't My Code Work? Literal Edition";
      server = {
        DOMAIN = "git.whydoesntmycode.work";
        ROOT_URL = "https://git.whydoesntmycode.work/";
        HTTP_PORT = 3001;
      };
      session = {
        COOKIE_SECURE = true; # Set the secure bit on cookies so they only are on HTTPS
      };
      service = {
        DISABLE_REGISTRATION = true;
        REGISTER_MANUAL_CONFIRM = true;
      };
      repository = {
        PREFERRED_LICENSES = lib.strings.concatStringsSep "," ["MPL-2.0" "AGPL-3.0-or-later" "GPL-3.0-or-later" "LGPL-3.0-or-later" "CC0-1.0" "Unlicense"];
      };
    };
  };

  services.dokuwiki.sites."dokuwiki.localhost" = {
    enable = true;
    settings = {
      title = "Whydoesntmycodework? DokuWiki Service";
      useacl = true;
      superuser = "admin";
      userewrite = true;
      baseurl = "https://wiki.whydoesntmycode.work";
      disableactions = ["register"];
      autopasswd = false;
    };
  };

  services.nginx.virtualHosts."wiki.whydoesntmycode.work" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://dokuwiki.localhost";
    };
  };

  services.nginx.virtualHosts."git.whydoesntmycode.work" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001/";
    };
  };
}
