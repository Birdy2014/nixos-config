{ ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1af071e5-c146-45c5-9060-578e98e48415";
    fsType = "btrfs";
    options = [
      "subvol=rootfs"
      "compress=zstd"
      "noatime"
      "nosuid"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1af071e5-c146-45c5-9060-578e98e48415";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
      "nosuid"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1af071e5-c146-45c5-9060-578e98e48415";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
      "nodev"
      "nosuid"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/1af071e5-c146-45c5-9060-578e98e48415";
    fsType = "btrfs";
    options = [
      "subvol=swap"
      "compress=zstd"
      "nodev"
      "nosuid"
      "noexec"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7941-AA55";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
      "umask=0077"
      "noatime"
      "nodev"
      "nosuid"
      "noexec"
    ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
}
