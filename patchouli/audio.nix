{ config, lib, pkgs, ... }:

# Mostly for audio production stuff.
# This is where my DAWs and VSTs go.
{
  home.packages = with pkgs; [
    # DAW
    ardour
    # VSTs
    surge-XT

  ];
}
