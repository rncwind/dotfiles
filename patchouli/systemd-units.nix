{ config, lib, pkgs, ... }:

{
  # Hack around sway's kind of bad handling of alerting systemd that it has started.
  # Services that are to start after sway (anything with a tray icon etc)
  # should depend on sway-session.
  systemd.user.services.sway-session = {
    unit = {
      description = "Placeholder for sway startup for other targets";
      after = [ "graphical-session.pre.target" ];
      wants = [ "graphical-session.pre.target" ];
      bindsto = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.keepassxc = {
    Unit = {
      Description = "Start KeepassXC on graphical session";
      #After = [ "graphical-session.target" ];
      #PartOf = [ "graphical-session.target" ];
      bindsto = [ "sway-session.target" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = { ExecStart = "${pkgs.keepassxc}/bin/keepassxc -platform xcb"; };
  };
}
