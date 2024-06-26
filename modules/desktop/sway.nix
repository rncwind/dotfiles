{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib;
with types; let
  cfg = config.modules.desktop.sway;
in {
  options = {
    modules.desktop.sway.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable sway";
    };

    modules.desktop.sway.usexwayland = mkOption {
      type = types.bool;
      default = true;
      description = "Use xwayland or not";
    };

    modules.desktop.sway.terminal = mkOption {
      type = types.str;
      default = "alacritty";
      description = "The terminal sway starts on Mod1+Enter";
    };

    modules.desktop.sway.xkb_layout = mkOption {
      type = types.str;
      default = "gb";
      description = "Keyboard layout for xkb";
    };

    modules.desktop.sway.xkb_options = mkOption {
      type = types.str;
      default = "ctrl:nocaps";
      description = "Additional options for xkb. Default sets ctrl on caps";
    };

    modules.desktop.sway.bars = mkOption {
      #type = listOf submodule;
      default = [];
      description = "Sway bars. Default is empty set as we use waybar";
    };
  };

  config = mkIf cfg.enable {
    programs.sway.enable = cfg.enable;

    home-manager.users.${config.user.name} = {
      wayland.windowManager.sway = {
        enable = cfg.enable;
        xwayland = cfg.usexwayland;

        extraConfig = ''
          gaps inner 10
          gaps outer 5
          exec_always autotiling
          output HDMI-A-1 pos 0 0 res 1920x1080
          output DP-1 pos 1920 0 res 2560x1440
          output HDMI-A-2 pos 4480 0 res 1920x1080
          workspace 3 output HDMI-A-1
          workspace 2 output HDMI-A-2
          workspace 1 output DP-1
          smart_gaps on
          smart_borders on
          bindsym Print exec 'grim -g "$(slurp)" - | oxipng - --stdout -q -o5 --timeout 3 | wl-copy -t image/png'
          bindsym Shift+Print exec 'grim -g "$(slurp)" - | oxipng - --stdout -q -o5 --timeout 3 > /tmp/screenshot.png'
          bindsym Mod1+Shift+Control+p exec "systemctl poweroff"
          bindsym Mod1+Shift+Control+e exec "emacsclient --eval \"(emacs-everywhere)\""
          exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
          exec hash dbus-update-activation-environment 2>/dev/null && \
            dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
          exec_always "systemctl --user import-environment; systemctl --user start sway-session.target"
          assign [app_id="slack"] 3
          assign [app_id="discord"] 3
          bar swaybar_command waybar
        '';

        extraSessionCommands = ''
          GTK_IM_MODULE=fcitx
          QT_IM_MODULE=fcitx
          XMODIFIERS=@im=fcitx
          export _JAVA_AWT_WM_NONREPARENTING=1
        '';

        config = {
          terminal = cfg.terminal;
          bars = [];
          input."*" = {
            xkb_layout = cfg.xkb_layout;
            xkb_options = cfg.xkb_options;
          };
          # Disable accel for the trackball.
          input."1133:16495:Logitech_MX_Ergo" = {
            accel_profile = "flat";
            pointer_accel = "0.0";
          };
        };
      };
    };
  };
}
