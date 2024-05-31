{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with types; let
  cfg = config.modules.desktop.threed;
in {
  options = {
    modules.desktop.threed = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable 3d printer stuff";
      };

      printers = mkOption {
        type = types.bool;
        default = false;
        description = "Enable 3d printer stuff";
      };

      openscad = mkOption {
        type = types.bool;
        default = false;
        description = "Enable OpenSCAD";
      };

      freecad = mkOption {
        type = types.bool;
        default = false;
        description = "Enable FreeCAD.";
      };

      cadquery = mkOption {
        type = types.bool;
        default = false;
        description = "Enable cadquery and it's editor";
      };

      eda = mkOption {
        type = types.bool;
        default = false;
        description = "EDA tools like KiCAD";
      };
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      []
      ++ (
        if cfg.printers
        then [cura orca-slicer bambu-studio]
        else []
      )
      ++ (
        if cfg.openscad
        then [openscad openscad-lsp]
        else []
      )
      ++ (
        if cfg.freecad
        then [freecad bottles]
        else []
      )
      ++ (
        if cfg.cadquery
        then [python311Packages.cadquery cq-editor]
        else []
      )
      ++ (
        if cfg.eda
        then [kicad-small]
        else []
      );
  };
}
