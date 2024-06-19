# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zfs.nix
    ./usenet.nix
    ./torrent.nix
    ./jellyfin.nix
    ./samba.nix
    ./audiobookshelf.nix
    ./calibre-web.nix
  ];
  networking = {
    hostName = "neodymium"; # Define your hostname.
  };

  boot = {
    loader = {
      # Bootloader.
      grub.enable = true;
      grub.device = "/dev/disk/by-id/ata-CT1000BX500SSD1_2247E688AF9C";
    };
    supportedFilesystems = ["zfs"];
    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";
  users.users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    nessie = {
      isNormalUser = true;
      description = "nessie";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINj3LyG4dzz76CJaSi+ukitHDADqAyIgttbkwD7S39Dv emilia@tzeentch"
      ];
    };

    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINj3LyG4dzz76CJaSi+ukitHDADqAyIgttbkwD7S39Dv emilia@tzeentch"
      ];
    };
  };

  users.groups = {
    pooluser = {
      name = "pooluser";
      members = ["root" "nessie" "transmission" "flood" "audiobookshelf"];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    ranger
    lsof
    fd
    ripgrep
    fzf
    gdu
    mediainfo
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [22 13120];
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "200m";
  };

  networking.firewall = {
    # We trust the tailnet.
    trustedInterfaces = ["tailscale0"];
  };
  networking.firewall.enable = false;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
