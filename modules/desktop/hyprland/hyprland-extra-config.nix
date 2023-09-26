{}: ''
  # Config Options
  general {
    gaps_in = 10
    gaps_out = 5
    border_size = 0
    layout = dwindle
    cursor_inactive_timeout = 0
  }
  decoration {
    rounding = 5
    blur = true
    blur_size = 4
    blur_new_optimizations = true
  }
  animations {
    enabled = true
  }
  input {
    kb_layout = gb
    kb_options = ctrl:nocaps
  }
  dwindle {
    preserve_split = true
    no_gaps_when_only = true # Smart gaps!
  }


  # Keybinds
  $mod = ALT
  $hyper = $modSHIFT
  $meh = $hyperCTRL

  bind = $mod,Return,exec,alacritty
  bind = $hyper,q,killactive
  bind = $meh,p,exec,systemctl poweroff
  bind = $mod,d,exec,rofi -show drun
  bind = $meh,e,exec,hyprctl dispatch exit
  bind = $meh,space,togglefloating
  bind = $mod,f,fullscreen

  ## Switch focus
  bind = $mod, left, movefocus, l
  bind = $mod, h, movefocus, l
  bind = $mod, right, movefocus, r
  bind = $mod, l, movefocus, r
  bind = $mod, down, movefocus, d
  bind = $mod, j, movefocus, d
  bind = $mod, up, movefocus, u
  bind = $mod, k, movefocus, u

  ## Move windows around
  bind=$hyper,left,movewindow,l
  bind=$hyper,right,movewindow,r
  bind=$hyper,up,movewindow,u
  bind=$hyper,down,movewindow,d
  bind=$hyper,h,movewindow,l
  bind=$hyper,l,movewindow,r
  bind=$hyper,k,movewindow,u
  bind=$hyper,j,movewindow,d

  ## Dwindle related controls
  bind=$hyper,P,pseudo # Enable pseudo tiling
  bind=$hyper,S,togglesplit

  ## Misc
  bind=$meh,P,pin # Pin a window.

  ## Resize Submap
  bind=$mod,r,submap,resize
  submap=resize

  binde=,right,resizeactive,10 0
  binde=,left,resizeactive,-10 0
  binde=,up,resizeactive,0 -10
  binde=,down,resizeactive,0 10

  bind=,escape,submap,reset

  submap=reset


  # Workspaces
  monitor=eDP-1,1920x1080@60,0x0,1
  $mainMonitor = eDP-1

  ## Default to WS1
  workspace=$mainMonitor,1

  ## binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in ''
        bind = $mod, ${ws}, workspace, ${toString (x + 1)}
        bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
      ''
    )
    10)}

  # Autostarts
  exec-once=waybar
''
