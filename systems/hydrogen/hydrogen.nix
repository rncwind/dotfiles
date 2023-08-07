{ config, pkgs, lib, ... }:

let
  user = "user";
  hostname = "hydrogen";
in {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80 443 # NGINX http(s)
        53 # AdGuard DNS
        3000 # AdGuard WebUI
      ];
      allowedUDPPorts = [
        53 # AdGuard DNS
      ];
    };
  };

  environment.systemPackages = with pkgs; [ vim tailscale ];

  services.openssh.enable = true;

  users = {
    mutableUsers = true;
    users."${user}" = {
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"];
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      passwordFile = config.sops.secrets.userPassword.path;
    };
    users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaht3shCbIVA1wzW4a9yZfd5JWHCKN3/V/dpXAFf2Eu patchouli@SDM"];
  };

  modules = {
    secrets = {
      enable = true;
      expose = {
        ssid = {owner = "user";};
        ssidPassword = { owner = "user"; };
        userPassword = { owner = "user"; };
      };
      keyFilePath = "/home/user/.config/sops/age/keys.txt";
      secretsFile = ../../secrets/hosts/hydrogen/hydrogen.yaml;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."hydrogen.local" = {
      serverName = "hydrogen.local";
      locations."/" = {
        proxyPass = "http://0.0.0.0:9001";
        proxyWebsockets = true;
      };
    };

    virtualHosts."adguard.local" = {
      serverName = "adguard.local";
      locations."/" = {
        proxyPass = "http://0.0.0.0:3000";
        proxyWebsockets = true;
      };
    };

    virtualHosts.${config.services.grafana.settings.server.domain} = {
      serverName = config.services.grafana.settings.server.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };

    virtualHosts."prometheus.local" = {
      serverName = "prometheus.local";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
        proxyWebsockets = true;
      };
    };
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      bind_host = "192.168.1.2";
      bind_port = 3000;
    };
  };

  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.local";
      http_port = 3001;
      http_addr = "127.0.0.1";
    };
  };

  services.prometheus = {
    enable = true;
    port = 3002;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9001;
      };
    };

    scrapeConfigs = [
      {
        job_name = "Hydrogen";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
