{ config, lib, pkgs, inputs, options, ... }:
with lib; let
  cfg = config.user;
in
{
  options.user = with types; {
    name = mkOption {
      type = str;
      default = "patchouli";
    };

    description = mkOption {
      type = str;
      default = "She may be gloomy, but she listens to hip hop and stuff";
    };

    homeDir = mkOption {
      type = str;
      default = "/home/patchouli";
    };

    # Home manager stuff. This is mostly used so we can install non-moduled
    # pacakges and similar.
    home = {
      packages = mkOption {
        type = listOf package;
        default = [ ];
      };
    };
  };
}
