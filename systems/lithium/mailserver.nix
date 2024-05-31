{
  config,
  lib,
  pkgs,
  domain,
  ...
}: let
  domain = "whydoesntmycode.work";
in {
  mailserver = {
    enable = true;
    fqdn = "mail.${domain}";
    domains = ["${domain}"];
    # We already run nginx, so we shoudl do this instead.
    certificateScheme = "acme-nginx";
    loginAccounts = {
      "rncwnd@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/passwords/rncwnd".path;
        aliases = ["admin@${domain}" "postmaster@${domain}"];
        aliasesRegexp = ["rncwnd(\+.*)?@whydoesntmycode\.work"];
      };
      "emilia@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/passwords/emilia".path;
      };
    };
  };

  services.roundcube = {
    enable = true;
    hostName = "webmail.${domain}";
    extraConfig = ''
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
      $rcmail_config['username_domain'] = '${domain}';
    '';
  };
}
