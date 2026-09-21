{ ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a28e54dc-8fe6-4cd0-9898-5971ea8f68a0";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd:3"
      "noatime"
      "nosuid"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/a28e54dc-8fe6-4cd0-9898-5971ea8f68a0";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd:3"
      "noatime"
      "nodev"
      "nosuid"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/a28e54dc-8fe6-4cd0-9898-5971ea8f68a0";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "compress=zstd:3"
      "noatime"
      "nodev"
      "nosuid"
      "noexec"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6F50-C8A2";
    fsType = "vfat";
    options = [
      "umask=0077"
      "noatime"
      "nodev"
      "nosuid"
      "noexec"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/ed5eceab-bd11-4cd4-bc3a-43a6583692b9"; } ];
}
