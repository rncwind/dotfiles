{ config, lib, pkgs, ... }:

{
  systemd.user.services.keepassxc = {
    Unit = {
      Description = "Start KeepassXC on graphical session";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = { WantedBy = [ "graphical-session.targetW" ]; };
    Service = { ExecStart = "${pkgs.keepassxc}/bin/keepassxc -platform xcb"; };
  };

}
