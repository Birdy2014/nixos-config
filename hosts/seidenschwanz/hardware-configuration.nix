{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f9bb18aa-2a76-44f7-877a-431b33fdb849";
    fsType = "btrfs";
    options = [ "subvol=rootfs" "noatime" "compress=zstd:1" ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/A314-8A92";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f9bb18aa-2a76-44f7-877a-431b33fdb849";
    fsType = "btrfs";
    options = [ "subvol=nix" "noatime" "compress=zstd:1" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/f9bb18aa-2a76-44f7-877a-431b33fdb849";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" "compress=zstd:1" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
