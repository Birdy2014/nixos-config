{ config, lib, pkgs, ... }:

{
  options.my.systemd-boot.enable = lib.mkEnableOption "systemd-boot";

  config = {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6;

    powerManagement.cpuFreqGovernor = "schedutil";

    boot.kernel.sysctl = {
      # Workaround for thunderbird crashes and potentially crashes of other applications.
      # https://github.com/swaywm/sway/issues/6292
      "net.core.wmem_default" = 21299200;
      "net.core.wmem_max" = 21299200;

      # Enable SysRq
      "kernel.sysrq" = 1;

      # Needed for some games
      "vm.max_map_count" = 2147483642;
    };

    boot.kernelParams = [ "nowatchdog" ];

    boot.tmp.useTmpfs = true;

    zramSwap.enable = true;

    services.dbus.implementation = "broker";

    services.udev.extraRules = ''
      # SATA SSDs
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"

      # NVMe SSDs
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

      # HDDs
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="mq-deadline"
    '';

    systemd.oomd.enableUserSlices = true;

    # TODO: Enable boot counting on NixOS 24.11
    boot.loader = lib.mkIf config.my.systemd-boot.enable {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      # Hold spacebar while booting to show the menu
      timeout = 0;
    };
  };
}
