{ lib, ... }:

{
  boot.initrd.luks.devices =
    let
      devices = {
        # Samsung SSD 980 PRO with Heatsink 2TB
        "nixos-root" = "/dev/disk/by-uuid/2710437f-5af4-46b1-a837-0c046c3e3209";

        # Samsung SSD 870 EVO 4TB
        "archive" = "/dev/disk/by-uuid/6198ff28-d300-4217-a480-a855ef0a8867";

        # Samsung SSD 870 QVO 2TB
        "archive2" = "/dev/disk/by-uuid/ff1db63b-e1b0-494e-8425-f20d23e9ffc1";

        # Crucial CT1000P1SSD8
        "archive3" = "/dev/disk/by-uuid/b66a028b-9986-4c08-b674-bb2c5129620b";
      };
    in
    lib.mapAttrs (name: device: {
      inherit device;
      bypassWorkqueues = true;
      allowDiscards = true;
    }) devices;

  fileSystems =
    let
      mkOptionsBtrfs =
        subvol: extra:
        [
          "subvol=${subvol}"
          "compress=zstd:1"
          "noatime"
          "nodev"
          "nosuid"
        ]
        ++ extra;

      bootSubvolumes = {
        "/" = mkOptionsBtrfs "rootfs" [ ];
        "/home" = mkOptionsBtrfs "home" [ ];
        "/nix" = mkOptionsBtrfs "nix" [ ];
        "/swap" = mkOptionsBtrfs "swap" [ "noexec" ];
        "/vm-images" = mkOptionsBtrfs "vm-images" [ "noexec" ];
        "/snapshots" = mkOptionsBtrfs "snapshots" [ "noexec" ];
      };

      archiveSubvolumes = {
        "/run/media/moritz/archive" = mkOptionsBtrfs "archive" [ "noexec" ];
        "/run/media/moritz/games" = mkOptionsBtrfs "games" [ ];
        "/run/media/moritz/snapshots" = mkOptionsBtrfs "snapshots" [ "noexec" ];
      };
    in
    (lib.mapAttrs (name: options: {
      device = "/dev/disk/by-uuid/b6d597be-f401-45a6-a7aa-e9c5498745f0";
      fsType = "btrfs";
      inherit options;
      neededForBoot = true; # Needed on /home for sops to find the key
    }) bootSubvolumes)
    // {
      "/boot" = {
        device = "/dev/disk/by-uuid/C01C-AFCC";
        fsType = "vfat";
        options = [
          "umask=0077"
          "noatime"
          "nodev"
          "nosuid"
          "noexec"
        ];
      };
    }
    // (lib.mapAttrs (name: options: {
      device = "/dev/disk/by-uuid/985dc3e3-86dc-48e2-9bd5-ee7b3ab798af";
      fsType = "btrfs";
      inherit options;
    }) archiveSubvolumes);

  swapDevices = [ { device = "/swap/swapfile"; } ];

  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [ "resume_offset=136908230" ];

  services.fstrim.enable = true;
}
