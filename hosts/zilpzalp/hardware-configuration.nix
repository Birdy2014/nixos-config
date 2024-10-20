{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.swraid.enable = false;

  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel ];

  boot.initrd.luks.devices."nixos-root" = {
    device = "/dev/disk/by-uuid/ab5e48e8-5eec-4e0e-a25c-ce869c544bf1";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a5b1135a-1c79-4bca-b56e-fd8d2dda921c";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:1" "noatime" "nosuid" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/a5b1135a-1c79-4bca-b56e-fd8d2dda921c";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:1" "noatime" "nosuid" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/a5b1135a-1c79-4bca-b56e-fd8d2dda921c";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:1" "noatime" "nodev" "nosuid" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/a5b1135a-1c79-4bca-b56e-fd8d2dda921c";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" "nodev" "nosuid" "noexec" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3A68-8541";
    fsType = "vfat";
    options = [ "umask=0077" "noatime" "nodev" "nosuid" "noexec" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; }];

  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [ "resume_offset=533760" ];

  services.fstrim.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0f1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
