{ config, lib, pkgs, ... }:

{
  home.sessionVariables = rec {
    EDITOR = "vim";
    RUST_BACKTRACE = 1;
    #SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    XDG_CACHE_HOME = "~/.cache";
    XDG_CONFIG_HOME = "~/.config";
    XDG_BIN_HOME = "~/.local/bin";
    XDG_DATA_HOME = "~/.local/share";
    # Steam needs this to find Proton-GE
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    # note: this doesn't replace PATH, it just adds this to it
    PATH = "${XDG_BIN_HOME}";
  };
}
