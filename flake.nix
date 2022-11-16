{
  description = "This is not a place of honor";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A better LSP for editing nix source files.
    nil-lsp = {
      url = "github:oxalica/nil#";
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
            ({ pkgs, ... }: {
              nixpkgs.overlays = [
                inputs.emacs-overlay.overlays.emacs
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
