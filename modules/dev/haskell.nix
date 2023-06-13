{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.types; let
  cfg = config.modules.dev.haskell;
  self = modules.dev.haskell;
in {
  options = {
    modules.dev.haskell.enable = mkOption {
      type = bool;
      default = false;
      description = "Enable haskell tools";
    };

    modules.dev.haskell.cabal = mkOption {
      type = bool;
      default = false;
      description = "Enable Cabal, a haskell build tool";
    };

    modules.dev.haskell.stack = mkOption {
      type = bool;
      default = false;
      description = "Enable Stack. The other haskell build tool";
    };

    modules.dev.haskell.buildTools = mkOption {
      type = bool;
      default = false;
      description = "Enable stack and cabal. Supersedes those options";
    };

    modules.dev.haskell.hls = mkOption {
      type = bool;
      default = false;
      description = "Enable the haskell language server";
    };

    modules.dev.haskell.hoogle = mkOption {
      type = bool;
      default = false;
      description = "Enable a local instance of haskell's search engine, hoogle";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages =
      []
      ++ (
        # Placeholder for if we want to set ghc here or something.
        if cfg.enable
        then []
        else []
      )
      ++ (
        if cfg.cabal or cfg.buildTools
        then [pkgs.haskellPackages.cabal-install]
        else []
      )
      ++ (
        if cfg.stack or cfg.buildTools
        then [pkgs.stack]
        else []
      )
      ++ (
        if cfg.hls
        then [pkgs.haskell-language-server]
        else []
      )
      ++ (
        if cfg.hoogle
        then [pkgs.haskellPackages.hoogle]
        else []
      );
  };
}
