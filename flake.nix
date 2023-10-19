{
  description = "This is not a place of honor";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-main.url = "github:nixos/nixpkgs";

    # --- Overlay flakes ---
    # emacs-overlay = {
    #   # Pinned to version as of 2023-08-29
    #   url = "github:nix-community/emacs-overlay/32cf0314159f4b2eb85970483124e7df730e3413";
    # };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Flake Modules ---
    home-manager = {
      # Home-manager exposes more config options for packages.
      url = "github:nix-community/home-manager";
    };

    sops-nix = {
      # Secrets OPerationS. Manages my secrets.
      url = "github:Mic92/sops-nix";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
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
              #inputs.emacs-overlay.overlays.emacs
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

      # Pi
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
              #inputs.emacs-overlay.overlays.emacs
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

      # Hetzner dedi
      lithium = lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          ./systems/lithium/lithium.nix
          ./modules
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      neodymium = lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          ./systems/neodymium/neodymium.nix
        ];
        specialArgs = {
          inherit inputs;
          nixpkgs-main = (import inputs.nixpkgs-main) {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
          };
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

    deploy.nodes.hydrogen = {
      hostname = "hydrogen.cinnamon-moth.ts.net";
      fastConnection = true;
      remoteBuild = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.hydrogen;
      };
    };

    deploy.nodes.helium = {
      hostname = "helium.cinnamon-moth.ts.net";
      fastConnection = true;
      remoteBuild = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.helium;
      };
    };

    deploy.nodes.lithium = {
      hostname = "lithium.cinnamon-moth.ts.net";
      fastConnection = true;
      remoteBuild = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lithium;
      };
    };

    deploy.nodes.neodymium = {
      hostname = "192.168.1.42";
      fastConnection = true;
      remoteBuild = true;
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.neodymium;
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
