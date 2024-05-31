{
  description = "This is not a place of honor";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-manager exposes more config options for packages.
    home-manager.url = "github:nix-community/home-manager";

    # Secrets OPerationS. Manages my secrets.
    sops-nix.url = "github:Mic92/sops-nix";
    deploy-rs.url = "github:serokell/deploy-rs";
    #hyprland.url = "github:hyprwm/Hyprland";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    vs-overlay.url = "github:sshiroi/vs-overlay";
    foundryvtt = {
      url = "github:reckenrode/nix-foundryvtt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Our own stuff!
    whydoesntmycodework-blog.url = "github:rncwind/whydoesntmycodework";
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
              (import ./pkgs)
              #(import ./overlays.nix)
              inputs.rust-overlay.overlays.default
              inputs.vs-overlay.overlay
              # Overlay our own packages into nixpkgs.
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
      # hydrogen = lib.nixosSystem {
      #   system = "aarch64-linux";

      #   modules = [
      #     inputs.sops-nix.nixosModules.sops
      #     inputs.home-manager.nixosModules.home-manager
      #     ./systems/hydrogen/hydrogen.nix
      #     ./modules
      #   ];
      #   specialArgs = {
      #     inherit inputs;
      #   };
      # };

      # Dell Laptop
      # helium = lib.nixosSystem {
      #   system = "x86_64-linux";

      #   modules = [
      #     # Flake inputs
      #     inputs.home-manager.nixosModules.home-manager
      #     inputs.sops-nix.nixosModules.sops
      #     inputs.hyprland.nixosModules.default
      #     {programs.hyprland.package = null;}
      #     # Add overlays.
      #     ({pkgs, ...}: {
      #       nixpkgs.overlays = [
      #         #inputs.emacs-overlay.overlays.emacs
      #         inputs.rust-overlay.overlays.default
      #         # Overlay our own packages into nixpkgs.
      #         (import ./pkgs)
      #       ];
      #     })

      #     # My stuff.
      #     ./systems/helium/helium.nix
      #     ./modules
      #     ./users/satori/satori.nix
      #   ];
      #   specialArgs = {
      #     inherit inputs;
      #   };
      # };

      # Hetzner dedi
      lithium = lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          inputs.simple-nixos-mailserver.nixosModule
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
            config = {allowUnfree = true;};
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

    # deploy.nodes.hydrogen = {
    #   hostname = "hydrogen.cinnamon-moth.ts.net";
    #   fastConnection = true;
    #   remoteBuild = true;
    #   profiles.system = {
    #     user = "root";
    #     sshUser = "root";
    #     path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.hydrogen;
    #   };
    # };

    # deploy.nodes.helium = {
    #   hostname = "helium.cinnamon-moth.ts.net";
    #   fastConnection = true;
    #   remoteBuild = true;
    #   profiles.system = {
    #     user = "root";
    #     sshUser = "root";
    #     path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.helium;
    #   };
    # };

    deploy.nodes.lithium = {
      hostname = "lithium.cinnamon-moth.ts.net";
      fastConnection = true;
      remoteBuild = true;
      #sshOpts = ["-p" "13120"];
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
