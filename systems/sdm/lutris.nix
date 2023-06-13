{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.gnome3.adwaita-icon-theme
    (pkgs.lutris.override {
      extraPkgs = pkgs: [
      ];

      extraLibraries = pkgs: [
      ];
    })
  ];
}
