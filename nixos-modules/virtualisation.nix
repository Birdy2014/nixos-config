{ config, lib, pkgs, ... }:

let cfg = config.my.virtualisation;
in {
  options.my.virtualisation.enable = lib.mkEnableOption "podman, qemu, etc.";

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
      };

      libvirtd = {
        enable = true;
        onBoot = "ignore";

        # libvirt 10.9.0 delays shutdown for 5 seconds
        # should be fixed with the next version
        # https://bbs.archlinux.org/viewtopic.php?id=301825
        # https://gitlab.com/libvirt/libvirt/-/issues/695
        package = pkgs.libvirt.overrideAttrs {
          version = "10.8.0";
          src = pkgs.fetchFromGitLab {
            owner = "libvirt";
            repo = "libvirt";
            rev = "v10.8.0";
            hash = "sha256-MzfkpWvj0RTjrse/TzoFDfPdfQk6PkOx0CsTF99zveA=";
            fetchSubmodules = true;
          };
        };

        qemu = {
          package = pkgs.qemu_kvm;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };

    programs.dconf.enable = true;
    users.users.moritz.extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; [
      distrobox
      virt-manager
      virtiofsd
    ];
  };
}
