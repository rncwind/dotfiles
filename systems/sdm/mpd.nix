{
  config,
  lib,
  pkgs,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = "/home/patchouli/music";
    user = "patchouli";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My Pipewire Output"
      }
      replaygain "auto"
    '';
    startWhenNeeded = true; # Use systemd so mpd only starts when we connect to it
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };
}
