{ config, lib, pkgs, inputs, ... }:

{
  modules = {
    shell = {
      fish.enable = true;
      alacritty.enable = true;
    };
  };
}
