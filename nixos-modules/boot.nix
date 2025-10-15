{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.systemd-boot.enable = lib.mkEnableOption "systemd-boot";

  config = {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    boot.swraid.enable = lib.mkForce false;

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

      # Same values as ArchLinux
      # Workaround for paperless-ngx build, maybe useful for other applications?
      "fs.inotify.max_user_instances" = 1024;
      "fs.inotify.max_user_watches" = 524288;
    };

    boot.kernelParams = [
      "nowatchdog"

      # zswap
      "zswap.enabled=1"
    ];

    # TODO: nix 2.30: build-dir is moved to /nix/var/nix/builds, so /tmp can be mounted as noexec?
    boot.tmp.useTmpfs = true;

    services.dbus.implementation = "broker";

    services.udev.extraRules = ''
      # SATA SSDs
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"

      # NVMe SSDs
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

      # HDDs
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="mq-deadline"
    '';

    # Because systemd-oomd kills whole cgroups, unexpected things can happen.
    # earlyoom seems to work better
    systemd.oomd.enable = false;
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
    };
    services.systembus-notify.enable = true;

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
