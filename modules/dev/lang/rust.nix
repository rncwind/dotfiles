{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib; let
  cfg = config.modules.dev.lang.rust;
in {
  options = {
    modules.dev.lang.rust.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable rust tooling";
    };

    modules.dev.lang.rust.rust-analyzer = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Rust Analyzer, the rust language server";
    };

    modules.dev.lang.rust.rust-analyzer-unwrapped = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Rust Analyzer (Unwrapped), the rust language server";
    };

    modules.dev.lang.rust.rust-stable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable stable rust from oxalica's overlay";
    };

    modules.dev.lang.rust.rust-beta = mkOption {
      type = types.bool;
      default = false;
      description = "Enable beta rust from Oxalica's overlay";
    };

    modules.dev.lang.rust.rust-nightly = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nightly rust from Oxalica's overlay";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      []
      ++ (
        if cfg.rust-analyzer
        then [rust-analyzer]
        else []
      )
      ++ (
        if cfg.rust-analyzer-unwrapped
        then [rust-analyzer-unwrapped]
        else []
      )
      ++ (
        if cfg.rust-stable
        then [rust-bin.stable.latest.default]
        else []
      )
      ++ (
        if cfg.rust-beta
        then [rust-bin.beta.latest.default]
        else []
      )
      ++ (
        if cfg.rust-nightly
        then [rust-bin.nightly.latest.default]
        else []
      );
  };
}
