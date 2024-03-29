{
  config,
  lib,
  pkgs,
  sops-nix,
  ...
}:
with lib;
with lib.types; let
  cfg = config.modules.secrets;
in {
  options.modules.secrets = {
    enable = mkOption {
      description = "Enable secrets handling with sops";
      type = bool;
      default = false;
    };

    expose = mkOption {
      description = "A list of the secrets we wish to expose.";
    };

    keyFilePath = mkOption {
      description = "A path to the age keyfile";
      type = str;
    };

    secretsFile = mkOption {
      description = "A path to the secrets file we want to load from.";
      type = path;
    };
  };

  config = mkIf cfg.enable {
    sops.age.keyFile = cfg.keyFilePath;
    sops.defaultSopsFile = cfg.secretsFile;

    sops.secrets = cfg.expose;
  };
}
