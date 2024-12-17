{ ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f9bb18aa-2a76-44f7-877a-431b33fdb849";
    fsType = "btrfs";
    options = [ "subvol=rootfs" "compress=zstd:1" "noatime" "nosuid" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f9bb18aa-2a76-44f7-877a-431b33fdb849";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:1" "noatime" "nodev" "nosuid" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/f9bb18aa-2a76-44f7-877a-431b33fdb849";
    fsType = "btrfs";
    options =
      [ "subvol=swap" "compress=zstd:1" "noatime" "nodev" "nosuid" "noexec" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A314-8A92";
    fsType = "vfat";
    options = [ "umask=0077" "noatime" "nodev" "nosuid" "noexec" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; }];
}
