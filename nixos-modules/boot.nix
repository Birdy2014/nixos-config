{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.systemd-boot.enable = lib.mkEnableOption "systemd-boot";

  config = {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
    boot.swraid.enable = lib.mkForce false;

    boot.initrd.systemd = {
      enable = true;

      # https://github.com/NixOS/nixpkgs/issues/250003#issuecomment-3179786204
      settings.Manager.DefaultDeviceTimeoutSec = "infinity";
    };

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

    fileSystems."/tmp" = {
      fsType = "tmpfs";
      options = [
        "mode=1777"
        "strictatime"
        "rw"
        "nosuid"
        "nodev"
        "size=50%"
        "noexec"
      ];
    };

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
      enableNotifications = config.my.desktop.enable;
    };
    services.systembus-notify.enable = config.my.desktop.enable;

    services.chrony = {
      enable = true;
      extraConfig = ''
        makestep 5 3
      '';
    };

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
