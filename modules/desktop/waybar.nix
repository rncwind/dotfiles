{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib;
with types; let
  cfg = config.modules.desktop.waybar;
in {
  options = {
    modules.desktop.waybar.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable waybar";
    };

    modules.desktop.waybar.hyprland = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprland mode rather than sway";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.waybar = mkIf cfg.enable {
        enable = true;
        style = ../../static/waybar_style.css;
        settings = [
          {
            layer = "top";
            position = "bottom";
            height = 25;
            #modules-left = ["sway/workspaces" "sway/mode"];
            modules-left =
              []
              ++ (
                if cfg.hyprland
                then ["hyprland/workspaces" "hyprland/submap"]
                else ["sway/workspaces" "sway/mode"]
              );
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
              format = "󰋊 {used}/{free} ({percentage_used}%)";
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
              format = "󰍛 {}%";
              states = {
                warning = 70;
                critical = 90;
              };
            };

            "network" = {
              interval = 5;
              format-ethernet = "󰱓 {ifname}: {ipaddr}/{cidr}";
              format-disconnected = "⚠  Disconnected";
            };

            "sway/workspaces" = {all-outputs = false;};

            "temperature" = {
              critical-threshold = 80;
              interval = 5;
              format = "{icon}  {temperatureC}°C";
              format-icons = ["" "" "" "" ""];
            };

            "tray" = {
              icon-size = 18;
              spacing = 10;
            };
          }
        ];
      };
    };
  };
}
