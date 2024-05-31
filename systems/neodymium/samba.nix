{
  config,
  lib,
  pkgs,
  ...
}: {
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
}
