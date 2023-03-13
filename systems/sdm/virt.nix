{ config, lib, pkgs, ... }:

# Configure VMs and stuff that this system has.

{
  programs.dconf.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    # sharedDirectories = {
    #   test = {
    #     source = "/home/patchouli/vm_shared";
    #     target = "/media/vm_shared";
    #   };
    # };
    #virtualbox.host.enable = true;
  };
  #users.extraGroups.vboxusers.members = [ "patchouli" ];
}
