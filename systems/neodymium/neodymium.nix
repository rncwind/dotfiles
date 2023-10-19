# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  nixpkgs-main,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zfs.nix
    ./usenet.nix
    ./torrent.nix
    ./jellyfin.nix
  ];
  networking = {
    hostName = "neodymium"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
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
      members = ["root" "nessie" "transmission" ];
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
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
  };
  networking.firewall.enable = false;

  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = neodymium_smb
      netbios name = neodymium_smb
      security = user
      hosts allow = 192.168.1. 127.0.0.1 localhost
      guest account = nobody
      map to guest bad user
    '';

    shares = {
      series = {
        path = "/mnt/nas-pool/media/complete/Series";
        browsable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
      movies = {
        path = "/mnt/nas-pool/media/complete/Movies";
        browsable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
      anime = {
        path = "/mnt/nas-pool/media/rtorrent/anime";
        browsable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
    };
  };

  services.tailscale.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
