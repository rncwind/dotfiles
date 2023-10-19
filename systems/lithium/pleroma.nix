{
  config,
  lib,
  pkgs,
  ...
}: {
  services.pleroma = {
    enable = true;
    secretConfigFile = "/var/lib/pleroma/secrets.exs";
    configs = [
      ''
        # Pleroma instance configuration

        # NOTE: This file should not be committed to a repo or otherwise made public
        # without removing sensitive information.

        import Config

        config :pleroma, Pleroma.Web.Endpoint,
           url: [host: "social.whydoesntmycode.work", scheme: "https", port: 443],
           http: [ip: {127, 0, 0, 1}, port: 4000]

        config :pleroma, :instance,
          name: "Why Doesn't My Code Work?",
          email: "admin@whydoesntmycode.work",
          notify_email: "admin@whydoesntmycode.work",
          limit: 5000,
          registrations_open: true

        config :pleroma, :media_proxy,
          enabled: false,
          redirect_on_failure: true
          #base_url: "https://cache.pleroma.social"

        config :pleroma, Pleroma.Repo,
          adapter: Ecto.Adapters.Postgres,
          username: "pleroma",
          database: "pleroma",
          hostname: "localhost"

        # Configure web push notifications
        config :web_push_encryption, :vapid_details,
          subject: "mailto:admin@whydoesntmycode.work"

        config :pleroma, :database, rum_enabled: false
        config :pleroma, :instance, static_dir: "/var/lib/pleroma/static"
        config :pleroma, Pleroma.Uploaders.Local, uploads: "/var/lib/pleroma/uploads"


        config :pleroma, configurable_from_database: true

        config :pleroma, Pleroma.Upload, filters: [Pleroma.Upload.Filter.Exiftool.StripLocation, Pleroma.Upload.Filter.Exiftool.ReadDescription]
      ''
    ];
  };

  services.nginx.virtualHosts."social.whydoesntmycode.work" = {
    enableACME = true;
    forceSSL = true;
    http2 = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4000";

      extraConfig = ''
        etag on;
        gzip on;

        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type, Idempotency-Key' always;
        add_header 'Access-Control-Expose-Headers' 'Link, X-RateLimit-Reset, X-RateLimit-Limit, X-RateLimit-Remaining, X-Request-Id' always;
        if ($request_method = OPTIONS) {
          return 204;
        }
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Permitted-Cross-Domain-Policies none;
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header Referrer-Policy same-origin;
        add_header X-Download-Options noopen;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;

        client_max_body_size 16m;
        # NOTE: increase if users need to upload very big files
      '';
    };
  };

  systemd.services.pleroma.path = [pkgs.exiftool];
}
