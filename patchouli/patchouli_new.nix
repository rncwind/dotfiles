{ config, lib, pkgs, inputs, ... }:

{
  modules = {
    shell = {
      fish.enable = true;
      alacritty.enable = true;
      terminalPrograms.enable = true;
    };

  };

  user = {
    #users.users.patchouli.extraGroups = [ "wheel" ];
    # Packages here don't have a programs.enable or a custom module.
    # In general, this is more of a "grab bag" of random utils etc.
    home.packages = with pkgs; [

    ];
  };

}
