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

  services.gitea = {
    enable = true;
    appName = "Why Doesn't My Code Work? Literal Edition";
    database = {
      type = "postgres";
      passwordFile = config.sops.secrets."gitea/postgresDBPass".path;
    };
    settings = {
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
      ui = {
        THEMES = lib.strings.concatStringsSep "," ["auto" "gitea" "arc-green" "dark-arc" "tangerine-dream" "github-dark" "catppuccin-macchiato-lavender" "catppuccin-frappe-lavender"];
      };
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
