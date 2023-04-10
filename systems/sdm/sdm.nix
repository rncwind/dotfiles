{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    trusted-substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
  imports = [ ./hardware-configuration.nix ./mpd.nix ./lutris.nix ./i18n.nix ./virt.nix ];
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libgdiplus
        keyutils
        libkrb5
        ncurses6
      ];
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Use tmpfs
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  # At high res grub draw in EFI is really slow.
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = {
    enc-pv = {
      name = "enc-pv";
      device = "/dev/disk/by-uuid/0cd3cd42-6568-4371-acb0-a5ac28d529d6";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking.hostName = "sdm"; # Define your hostname.

  # Graphics card block
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl = {
    enable = true;
    # Mesa OpenCL
    extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    # Enable vulkan
    driSupport = true;
    driSupport32Bit = true;
  };

  # i18
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console = { keyMap = "uk"; };
  services.xserver.layout = "uk";
  services.xserver.xkbOptions = "ctrl:nocaps";

  sound.enable = true;

  # users.users.patchouli = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [ ];
  # };

  # Ensure that we always have _at least_ vim and wget.
  environment.systemPackages = with pkgs; [ steam steam-run vim wget gcc xdg-utils SDL SDL2 polkit_gnome virtiofsd gnutls ];

  # Set vim as default
  programs.vim.defaultEditor = true;


  # Yubi
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Printing stuff.
  services.printing.enable = true;
  services.printing.drivers =
    [ pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  #services.avahi.userServices = true;
  services.printing.browsing = true;
  services.printing.allowFrom = [ "all" ];

  services.mullvad-vpn.enable = true;

  # Use pipewire because it's best.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Use portals for screenshares and things.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.gnome.gnome-keyring ];
  };


  programs.sway.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    daemon.settings = {
      features = {
        buildkit = true;
      };
    };
  };

  # GVFS
  services.gvfs.enable = true;
  # Generate thumbnails
  services.tumbler.enable = true;
  services.gnome.gnome-keyring.enable = true;
  # OpenSSH
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;

  # Polshit
  security.polkit.enable = true;

  nix.settings.trusted-users = [ "root" "patchouli" ];


  security.wrappers.gamescope = {
    owner = "patchouli";
    group = "users";
    capabilities = "CAP_SYS_NICE-eip";
    source = "${pkgs.gamescope}/bin/gamescope";
  };

  # Firewall config.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    42420 # Vintage Story
    57300 # Deluge
    2234 # SLSK
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
