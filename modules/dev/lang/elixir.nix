{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.lang.elixir;
in {
  options = {
    modules.dev.lang.elixir = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable elixir tooling";
      };
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs; [elixir elixir-ls lexical];
  };
}
