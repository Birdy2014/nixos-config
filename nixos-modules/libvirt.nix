{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.libvirt;
  isDesktop = config.my.desktop.enable;
in
{
  options.my.libvirt.enable = lib.mkEnableOption "libvirt";

  config = lib.mkIf cfg.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };
      spiceUSBRedirection.enable = isDesktop;
    };

    networking.firewall = {
      trustedInterfaces = [ "virbr0" ];
      extraForwardRules = lib.mkBefore ''
        iifname virbr0 accept
        oifname virbr0 accept
      '';
    };

    programs.dconf.enable = isDesktop;
    users.users = lib.mkIf isDesktop { moritz.extraGroups = [ "libvirtd" ]; };
    environment.systemPackages = lib.mkIf isDesktop (with pkgs; [ virt-manager ]);
  };
}
