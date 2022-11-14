# This boilerplate eventually appears in every nix config. It's the
# carcinisation of nix dotfiels
inputs: { host
        , customModules ? [ ]
        , arch ? "x86_64-linux"
        ,
        }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem lists optionalAttrs optionals;
  inherit (inputs) emacs-overlay home-manager;
  overlays.nixpkgs.overlays = lists.flatten [
    (import ../pkgs)
  ];
in
nixosSystem {
  inherit system;
  modules =
    customModules
    ++ [
      overlays
      ../modules
      ../hosts/${hostpath}/configuration.nix
    ];
}
