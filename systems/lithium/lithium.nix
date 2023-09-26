{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./gitea.nix
    ./nginx.nix
    #./headscale.nix
  ];

  # Use GRUB2 as the boot loader.
  # We don't use systemd-boot because Hetzner uses BIOS legacy boot.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    devices = ["/dev/sda" "/dev/sdb"];
  };

  # enable flakes by default
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # The mdadm RAID1s were created with 'mdadm --create ... --homehost=hetzner',
  # but the hostname for each machine may be different, and mdadm's HOMEHOST
  # setting defaults to '<system>' (using the system hostname).
  # This results mdadm considering such disks as "foreign" as opposed to
  # "local", and showing them as e.g. '/dev/md/hetzner:root0'
  # instead of '/dev/md/root0'.
  # This is mdadm's protection against accidentally putting a RAID disk
  # into the wrong machine and corrupting data by accidental sync, see
  # https://bugzilla.redhat.com/show_bug.cgi?id=606481#c14 and onward.
  # We do not worry about plugging disks into the wrong machine because
  # we will never exchange disks between machines, so we tell mdadm to
  # ignore the homehost entirely.
  environment.etc."mdadm.conf".text = ''
    HOMEHOST <ignore>
    MAILADDR admin+lithium@whydoesntmycode.work
  '';
  # The RAIDs are assembled in stage1, so we need to make the config
  # available there.
  #boot.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;

  environment = {
    # just a couple of packages to make our lives easier
    systemPackages = with pkgs; [vim];
  };
  networking = {
    hostName = "lithium";

    # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
    useDHCP = false;
    interfaces."enp0s31f6".ipv4.addresses = [
      {
        address = "188.40.119.252";
        # DONE! Netmask is 255.255.255.192 and thus 26
        prefixLength = 26;
      }
    ];
    interfaces."enp0s31f6".ipv6.addresses = [
      {
        address = "2a01:4f8:221:27c6::1";
        prefixLength = 64;
      }
    ];
    defaultGateway = "188.40.119.193";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp0s31f6";
    };
    nameservers = [
      # cloudflare
      "1.1.1.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      # google
      "8.8.8.8"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];

    # Always trust the tailnet.
    firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = [22 443]; # Let us SSH from the normal net.
      allowedUDPPorts = [config.services.tailscale.port 3478];
    };
  };

  services.openssh.enable = true;

  # Boilerplate done

  # Sops secrets
  sops = {
    defaultSopsFile = ../../secrets/hosts/lithium/lithium.yaml;
    age = {
      keyFile = "/root/.config/sops/age/keys.txt";
    };
    # secrets."users/passwords/user" = {
    #   neededForUsers = true;
    #   #owner = config.users.users.user.name;
    # };
    # secrets."users/passwords/root" = {
    #   neededForUsers = true;
    #   #owner = config.users.users.root.name;
    # };
    secrets."gitea/userPassword" = {
      neededForUsers = true;
      #owner = config.users.users.gitea.name;
    };
    secrets."gitea/postgresDBPass" = {
      owner = config.users.users.gitea.name;
    };
  };

  users = {
    mutableUsers = true;
    users."user" = {
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"];
      isNormalUser = true;
      extraGroups = ["wheel" "gitea"];
    };
    users."gitea" = {
      isNormalUser = false;
      isSystemUser = true;
      group = "gitea";
      passwordFile = config.sops.secrets."gitea/userPassword".path;
    };
    users.root = {
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"];
    };
    groups.gitea = {};
  };

  services.tailscale.enable = true;

  system.stateVersion = "23.05";
}
