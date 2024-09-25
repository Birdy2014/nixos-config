{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.swraid.enable = false;

  # Samsung SSD 980 PRO with Heatsink 2TB

  boot.initrd.luks.devices."nixos-root" = {
    device = "/dev/disk/by-uuid/2710437f-5af4-46b1-a837-0c046c3e3209";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b6d597be-f401-45a6-a7aa-e9c5498745f0";
    fsType = "btrfs";
    options = [ "subvol=rootfs" "compress=zstd:1" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b6d597be-f401-45a6-a7aa-e9c5498745f0";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:1" ];
    neededForBoot = true; # Needed for sops to find the key
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b6d597be-f401-45a6-a7aa-e9c5498745f0";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/b6d597be-f401-45a6-a7aa-e9c5498745f0";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" ];
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-uuid/b6d597be-f401-45a6-a7aa-e9c5498745f0";
    fsType = "btrfs";
    options = [ "subvol=snapshots" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C01C-AFCC";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  # Crucial CT1000P1SSD8

  boot.initrd.luks.devices."games" = {
    device = "/dev/disk/by-uuid/b66a028b-9986-4c08-b674-bb2c5129620b";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  fileSystems."/run/media/moritz/games" = {
    device = "/dev/disk/by-uuid/8b85ed66-baa2-42b4-b179-c0f6aaa2a555";
    fsType = "btrfs";
    options = [ "compress=zstd:1" "noatime" ];
  };

  # Samsung SSD 870 EVO 4TB

  boot.initrd.luks.devices."archive" = {
    device = "/dev/disk/by-uuid/6198ff28-d300-4217-a480-a855ef0a8867";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  fileSystems."/run/media/moritz/archive" = {
    device = "/dev/disk/by-uuid/985dc3e3-86dc-48e2-9bd5-ee7b3ab798af";
    fsType = "btrfs";
    options = [ "compress=zstd:3" "noatime" ];
  };

  # Samsung SSD 870 QVO 2TB

  boot.initrd.luks.devices."archive2" = {
    device = "/dev/disk/by-uuid/ff1db63b-e1b0-494e-8425-f20d23e9ffc1";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  # "archive2" is a part of the "archive" btrfs volume

  swapDevices = [{ device = "/swap/swapfile"; }];

  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [ "resume_offset=136908230" ];

  services.fstrim.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
