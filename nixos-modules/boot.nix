{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_4;

  programs.cfs-zen-tweaks.enable = true;

  boot.kernel.sysctl = {
    # Make system more responsive in case of OOM
    "vm.swappiness" = 10;

    # Workaround for thunderbird crashes and potentially crashes of other applications.
    # https://github.com/swaywm/sway/issues/6292
    "net.core.wmem_default" = 21299200;
    "net.core.wmem_max" = 21299200;

    # Enable SysRq
    "kernel.sysrq" = 1;
  };

  boot.kernelParams = [ "nowatchdog" ];

  boot.tmp.useTmpfs = true;
}
