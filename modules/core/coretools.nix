{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib;
  let cfg = config.modules.core.coretools;
in {
  options.modules.core.coretools = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable some common tools that we want on most systems";
    };

    archives = mkOption {
      type = types.bool;
      default = false;
      description = "Enable archive tools. zip, unzip, unrar etc";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      [sops age which coreutils-full sudo]
      ++ (
        if cfg.archives
        then [ zip unzip unrar ]
        else []
      );
  };
}
