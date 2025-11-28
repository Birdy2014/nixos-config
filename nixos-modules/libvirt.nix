{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.libvirt;
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

    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
