{
  description = "This is not a place of honor";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Overlay flakes ---
    emacs-overlay = {
      # Pinned to version as of 2023-08-29
      url = "github:nix-community/emacs-overlay/18db5f949c4a8d2c8a04e446092414fcd65e6bcd";
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

    hyprland.url = "github:hyprwm/Hyprland";

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
          ./users/patchouli/patchouli.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      # Dell Laptop
      helium = lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # Flake inputs
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.hyprland.nixosModules.default
          {programs.hyprland.package = null;}
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
          ./systems/helium/helium.nix
          ./modules
          ./users/satori/satori.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      hydrogen = lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          ./systems/hydrogen/hydrogen.nix
          ./modules
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };

    deploy.nodes.sdm = {
      hostname = "sdm.cinnamon-moth.ts.net";
      fastConnection = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.sdm;
      };
    };

    deploy.nodes.helium = {
      hostname = "helium.cinnamon-moth.ts.net";
      fastConnection = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.helium;
      };
    };

    deploy.nodes.hydrogen = {
      hostname = "192.168.1.2";
      fastConnection = true;
      remoteBuild = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.hydrogen;
      };
    };

    checks = builtins.mapAttrs(system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
