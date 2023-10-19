{
  config,
  lib,
  pkgs,
  modules,
  ...
}:
with lib; let
  cfg = config.modules.dev.dev-tools;
  gcloudWithPlugins = pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin];
in {
  options.modules.dev.dev-tools = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dev tools for this machine.";
    };

    git = mkOption {
      type = types.bool;
      default = false;
      description = "Enable git and git tools";
    };

    cloudTools = mkOption {
      type = types.bool;
      default = false;
      description = "Enable cloud tools like k9s, kubectl etc";
    };

    replicated = mkOption {
      type = types.bool;
      default = false;
      description = "Enable tooling for Replicated. Additional K8s stuff";
    };

    tldr = mkOption {
      type = types.bool;
      default = false;
      description = "Enable tldr, man pages for the lazy";
    };

    shellDev = mkOption {
      type = types.bool;
      default = false;
      description = "Enable bash language server, shellcheck and bashdb";
    };

    grpc = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GRPC tools like Evans or grpcurl";
    };

    apis = mkOption {
      type = types.bool;
      default = false;
      description = "Enable API Tools. For now this is Curl and Insomnia";
    };

    grabBag = mkOption {
      type = types.bool;
      default = false;
      description = "Various tools that don't fit anywhere else. Stuff like jq";
    };

    virt = mkOption {
      type = types.bool;
      default = false;
      description = "Enable virtualization tools like virt-manager";
    };

    linkers = mkOption {
      type = types.bool;
      default = false;
      description = "Alternate linkers. LLD and Mold";
    };

    asciinema = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Asciinema, a terminal recording system";
    };

    reversing = mkOption {
      type = types.bool;
      default = false;
      description = "Enable tools for reverse engineering. Objdump, gdb, pwndbg, ghidra";
    };
  };

  config = mkIf cfg.enable {
    user.home.packages = with pkgs;
      [fzf just sqlite exercism]
      ++ (
        if cfg.git
        then [git git-crypt gnupg tig]
        else []
      )
      ++ (
        if cfg.cloudTools
        then [kubectl k9s gcloudWithPlugins codeship-jet]
        else []
      )
      ++ (
        if cfg.replicated
        then [replicated-cli kots krew kubecm k3d]
        else []
      )
      ++ (
        if cfg.grabBag
        then [jq curl sem socat zellij]
        else []
      )
      ++ (
        if cfg.grpc
        then [grpcurl evans]
        else []
      )
      ++ (
        if cfg.apis
        then [curl insomnia]
        else []
      )
      ++ (
        if cfg.shellDev
        then [nodePackages_latest.bash-language-server shellcheck bashdb shfmt]
        else []
      )
      ++ (
        if cfg.virt
        then [virt-manager]
        else []
      )
      ++ (
        if cfg.linkers
        then [lld mold]
        else []
      )
      ++ (
        if cfg.asciinema
        then [asciinema asciinema-agg]
        else []
      )
      ++ (
        if cfg.reversing
        then [gdb pwndbg ghidra-bin]
        else []
      );
    #user.extraGroups = user.extraGroups ++ (if cfg.virt then ["libvirtd"] else []);

    home-manager.users.${config.user.name} = {
      programs.tealdeer = mkIf cfg.tldr {
        enable = cfg.tldr;
        settings = {
          display = {
            use_pager = true;
          };
          updates = {
            auto_update = true;
          };
        };
      };
    };
  };
}
