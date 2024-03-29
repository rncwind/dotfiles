# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/85538416-359a-4c58-b52b-c76521a476fd";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F399-05AC";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/98fe3a9a-5ca7-4844-b5a2-dfc4e0a54c9d";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
