{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.foundryvtt.nixosModules.foundryvtt];
  users.groups.foundry = {};
  users.users."foundry" = {
    isNormalUser = false;
    isSystemUser = true;
    home = "/home/foundry";
    createHome = true;
    group = "foundry";
    packages = [
      pkgs.bash
    ];
  };

  services.foundryvtt = {
    enable = true;
    hostName = "foundry.whydoesntmycode.work";
    proxySSL = true;
    proxyPort = 443;
  };

  services.nginx.virtualHosts."foundry.whydoesntmycode.work" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://0.0.0.0:30000";
      proxyWebsockets = true;
    };
  };

  # systemd.services.foundryvtt = {
  #   wantedBy = ["multi-user.target"];
  #   after = ["network.target"];
  #   description = "FoundryVTT";
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "foundry";
  #     WorkingDirectory = "/home/foundry/foundry/foundry/foundryvtt";
  #     ExecStart = ''
  #       ${pkgs.nodejs_18}/bin/node resources/app/main.js --dataPath=../data/
  #     '';
  #   };
  # };
}
