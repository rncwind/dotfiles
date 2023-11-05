{ config, lib, pkgs, inputs, ... }:

let
  blogdir = inputs.whydoesntmycodework-blog.packages.${pkgs.system}.default;

  script = ''
    export SOCKET_PATH=/srv/blog/socket
    cd ${blogdir}
    exec ${blogdir}/bin/whydoesntmycodework
  '';
in {
  users.users.blog = {
    createHome = true;
    description = "blog";
    isSystemUser = true;
    group = "blog";
  };
  users.groups.blog = {};

  systemd.services.blog = {
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "blog";
      Group = "blog";
      WorkingDirectory = "${blogdir}";
      Environment = "SOCKET_PATH=/srv/blog/socket";
      ExecStart = ''
        ${blogdir}/bin/whydoesntmycodework
      '';
    };
  };
}
