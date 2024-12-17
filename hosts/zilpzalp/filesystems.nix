{ ... }:

{
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
}
