{ config, lib, pkgs, ... }:

{
  boot.zfs = {
    extraPools = ["nas-pool"];
  };
  services.zfs.autoScrub.enable = true;
}
