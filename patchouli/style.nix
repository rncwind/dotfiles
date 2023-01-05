{ config, lib, pkgs, ... }:

let
  # Sway and GTK don't like eachother. As such we need to work around this
  # so we can use a GTK theme.
  # Specifically, sway tells us that we need to use gsettings, for that to work
  # we need to tell it where the gtk schemas are.
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  home.packages = with pkgs; [
    configure-gtk
  ];
}
