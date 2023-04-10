{
  description = "This is not a place of honor";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay?rev=6a2222bf037ac02d79f28c5455ec62adad699560";
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
            inputs.home-manager.nixosModules.home-manager
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
          ];
        };
      };
    };
}
