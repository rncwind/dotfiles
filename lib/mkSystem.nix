inputs: {
  host,
  extraMods ? [],
  system ? "x86_64-linux",
  path ? host,
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem lists optionalAttrs optionals;
  inherit (inputs) emacs-overlay home-manager;

  overlays.nixpkgs.overlays = lists.flatten [
    (import ../pkgs)
  ];
in
  nixosSystem {
    inherit system;
    modules =
      extraMods
      ++ [
        overlays
        ../modules
        ../hosts/${path}/configuration.nix
      ];

    specialArgs = {
      inherit inputs emacs-overlay host system;
    };
  }
