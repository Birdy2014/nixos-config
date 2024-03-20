{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6;

  powerManagement.cpuFreqGovernor = "schedutil";

  boot.kernel.sysctl = {
    # Make system more responsive in case of OOM
    "vm.swappiness" = 10;

    # Workaround for thunderbird crashes and potentially crashes of other applications.
    # https://github.com/swaywm/sway/issues/6292
    "net.core.wmem_default" = 21299200;
    "net.core.wmem_max" = 21299200;

    # Enable SysRq
    "kernel.sysrq" = 1;

    # Needed for some games
    "vm.max_map_count" = 2147483642;
  };

  boot.kernelParams = [
    "nowatchdog"

    # The mitigations have a significant performance impact e.g. in cpu-bound games. (At least on my zen2 cpu)
    "mitigations=off"
  ];

  boot.tmp.useTmpfs = true;

  zramSwap.enable = true;

  services.logind.powerKey = "ignore";

  services.dbus.implementation = "broker";

  # Use the kyber IO Scheduler for SSDs to improve responsiveness
  services.udev.extraRules = ''
    # SATA SSDs
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"

    # NVMe SSDs
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
  '';

  systemd.oomd.enableUserSlices = true;
}
