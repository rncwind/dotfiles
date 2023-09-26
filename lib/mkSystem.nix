{
  self,
  inputs,
}: let
  inherit (inputs) home-manager nixpkgs;
in {
  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    pkgs ? nixpkgs,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      modules = [
      ];
    };
}
