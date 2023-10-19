{
  config,
  lib,
  pkgs,
  ...
}: {
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

  systemd.services.foundryvtt = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "FoundryVTT";
    serviceConfig = {
      Type = "simple";
      User = "foundry";
      WorkingDirectory = "/home/foundry/foundry/foundry/foundryvtt";
      ExecStart = ''
        ${pkgs.nodejs_18}/bin/node resources/app/main.js --dataPath=../data/
      '';
    };
  };
}
