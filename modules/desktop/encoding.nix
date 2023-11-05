{ config, lib, pkgs, ... }:
with lib;
with types;

let
  cfg = config.modules.desktop.encoding;
  vsPlugins  = with pkgs.vapoursynthPlugins; [vsutil subtext awsmfunc pkgs.ffms];
in {
  options.modules.desktop.encoding = {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Enable normal encoding tools";
    };

    vapourSynth = mkOption {
      type = bool;
      default = false;
      description = "Enable vapoursynth. Uses the overlay";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      [ffmpeg_6-full mkvtoolnix mediainfo x264 bc]
      ++ (
        if cfg.vapourSynth
        then [(pkgs.vapoursynth.withPlugins vsPlugins)
              (vapoursynth-editor.withPlugins vsPlugins)
             ]
        else []
      );
  };
}
