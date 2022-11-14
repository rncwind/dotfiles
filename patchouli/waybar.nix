{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = ./static/waybar_style.css;
    settings = [{
      layer = "top";
      position = "bottom";
      height = 25;
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-right = [
        "network"
        "disk"
        "memory"
        "cpu"
        "temperature"
        "clock#date"
        "clock#time"
        "tray"
      ];

      "disk" = {
        interval = 30;
        format = " {used}/{free} ({percentage_used}%)";
        path = "/";
      };

      "clock#time" = {
        #timezone = "Europe/London";
        format = " {:%H:%M:%S}";
        interval = 1;
        tooltip = false;
      };

      "clock#date" = {
        interval = 60;
        format = " {:%Y-%m-%d (%a)}";
        tooltip = false;
      };

      "cpu" = {
        interval = 5;
        format = " {usage}% ({load})";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      "memory" = {
        interval = 5;
        format = " {}%";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      "network" = {
        interval = 5;
        format-ethernet = "歷 {ifname}: {ipaddr}/{cidr}";
        format-disconnected = "⚠  Disconnected";
      };

      "sway/workspaces" = { all-outputs = false; };

      "temperature" = {
        critical-threshold = 80;
        interval = 5;
        format = "{icon}  {temperatureC}°C";
        format-icons = [ "" "" "" "" "" ];
      };

      "tray" = {
        icon-size = 18;
        spacing = 10;
      };
    }];
  };
}
