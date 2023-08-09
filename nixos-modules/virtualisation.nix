{ config, lib, pkgs, ... }:

let cfg = config.my.virtualisation;
in {
  options.my.virtualisation.enable =
    lib.mkEnableOption (lib.mdDoc "Whether to enable podman, qemu, etc.");

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled.enable = true;
      };

      libvirtd = {
        enable = true;
        onBoot = "ignore";

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

    environment.systemPackages = with pkgs; [ distrobox virt-manager ];
  };
}
