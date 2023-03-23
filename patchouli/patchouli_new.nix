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
    home.packages = with pkgs; [

    ];
  };
}
