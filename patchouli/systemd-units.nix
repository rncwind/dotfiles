{ config, lib, pkgs, ... }:

{
  # Hack around sway's kind of bad handling of alerting systemd that it has started.
  # Services that are to start after sway (anything with a tray icon etc)
  # should depend on sway-session.
  systemd.user.services.sway-session = {
    Unit = {
      Description = "Placeholder for sway startup for other targets";
      After = [ "graphical-session.pre.target" ];
      Wants = [ "graphical-session.pre.target" ];
      BindsTo = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.keepassxc = {
    Unit = {
      Description = "Start KeepassXC on graphical session";
      #After = [ "graphical-session.target" ];
      #PartOf = [ "graphical-session.target" ];
      BindsTo = [ "sway-session.target" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = { ExecStart = "${pkgs.keepassxc}/bin/keepassxc -platform xcb"; };
  };

  systemd.user.services.slack-autostart = {
    Unit = {
      Description = "Autostart slack on weekdays";
      BindsTo = [ "sway-session.target" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = { ExecStart = "${./static/maybe_start_slack.sh}"; };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      WantedBy = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
