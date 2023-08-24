{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Samsung SSD 870 EVO 4TB

  boot.initrd.luks.devices."nixos-root" = {
    device = "/dev/disk/by-uuid/ec1f1df4-349f-43ca-aa22-8c60a5845a5a";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:1" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:1" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1820-B211";
    fsType = "vfat";
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

  # KINGSTON SA2000M8500G

  boot.initrd.luks.devices."500GBSSD" = {
    device = "/dev/disk/by-uuid/a3fbfddd-fbe9-4b6f-bc08-579810b18bae";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  fileSystems."/run/media/moritz/500GBSSD" = {
    device = "/dev/disk/by-uuid/2c8e25fe-d15d-44d5-bd9e-024f1e9a8fe0";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  # Samsung SSD 870 QVO 2TB

  boot.initrd.luks.devices."archive" = {
    device = "/dev/disk/by-uuid/ff1db63b-e1b0-494e-8425-f20d23e9ffc1";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  fileSystems."/run/media/moritz/archive" = {
    device = "/dev/disk/by-uuid/e86999be-1893-440c-80e9-9cee8af2fada";
    fsType = "ext4";
    options = [ "noatime" ];
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
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
