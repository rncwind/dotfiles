{pkgs, home-manager, system, lib, overlays, ...}:
rec {
  user = import ./mkUser.nix { inherit pkgs home-manager lib system overlays; };
  system = import ./mkSystem.nix { inherit system pkgs home-manager lib user; };
}
