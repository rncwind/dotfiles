{
  description = "This is not a place of honor";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay?rev=a0d2c39ee3fb673e0626213461d989418b1b1b7f";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
    };

    # A better LSP for editing nix source files.
    nil-lsp = {
      url = "github:oxalica/nil#";
    };

    # An uncompromising code formatter for nix
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { self, ... }:
    let
      system = "x86_64-linux";

      lib = inputs.nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        sdm = lib.nixosSystem {
          inherit system;
          # A module file is just a config file :tm:
          modules = [
            ./systems/sdm/sdm.nix
            ./modules
            ./patchouli/patchouli_new.nix
            ({ pkgs, ... }: {
              nixpkgs.overlays = [
                inputs.emacs-overlay.overlays.emacs
                inputs.rust-overlay.overlays.default
                (import ./pkgs)
              ];
            })
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.patchouli = import ./patchouli/patchouli.nix;
            }
          ];
        };
      };
    };
}
