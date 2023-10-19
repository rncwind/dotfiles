{ config, lib, pkgs, ... }:

{
  boot.zfs = {
    extraPools = ["nas-pool"];
  };
  networking.hostId = "eba5a815";
  #services.zfs.autoScrub.enable = true;

  environment.systemPackages = with pkgs; [
    zfs
  ];
}
