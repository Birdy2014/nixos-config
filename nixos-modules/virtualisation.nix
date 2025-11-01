{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.virtualisation;
in
{
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
        qemu = {
          package = pkgs.qemu_kvm;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };

    networking.firewall = {
      trustedInterfaces = [ "virbr0" ];
      extraForwardRules = lib.mkBefore ''
        iifname virbr0 accept
        oifname virbr0 accept
      '';
    };

    programs.dconf.enable = true;
    users.users = lib.mkIf config.my.desktop.enable { moritz.extraGroups = [ "libvirtd" ]; };

    environment.systemPackages = with pkgs; [
      distrobox
      virt-manager
      virtiofsd
    ];
  };
}
