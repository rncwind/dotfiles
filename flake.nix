{
  description = "This is not a place of honor";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Overlay flakes ---
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Flake Modules ---
    home-manager = {
      # Home-manager exposes more config options for packages.
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      # Secrets OPerationS. Manages my secrets.
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {self, ...}: let
    lib = inputs.nixpkgs.lib;
  in {
    nixosConfigurations = {
      # Desktop computer.

      sdm = lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # Flake inputs
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          # Add overlays.
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.emacs-overlay.overlays.emacs
              inputs.rust-overlay.overlays.default
              # Overlay our own packages into nixpkgs.
              (import ./pkgs)
            ];
          })

          # My stuff.
          ./systems/sdm/sdm.nix
          ./modules
          ./patchouli/patchouli_new.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      #rhea = lib.nixosSystem {
      #system = "x86_64-linux";
      #modules = [
      #inputs.home-manager.nixosModules.home-manager
      #inputs.sops-nix.nixosModules.sops
      #./modules
      #./systems/rhea/rhea.nix
      #({ pkgs, ... }: {
      #nixpkgs.overlays = [
      #inputs.emacs-overlay.overlays.emacs
      #inputs.rust-overlay.overlays.default
      #(import ./pkgs)
      #];
      #})
      #];

      #};
    };

    #deploy.nodes.sdm.profiles.system = {
    #hostname = "sdm";
    #user = "root";
    #path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.sdm;
    #};

    #checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
