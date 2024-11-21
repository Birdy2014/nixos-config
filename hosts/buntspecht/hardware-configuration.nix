{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
    options = [ "noatime" "nosuid" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/01D2-08DB";
    fsType = "vfat";
    options = [ "umask=0077" "noatime" "nodev" "nosuid" "noexec" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; }];
}
