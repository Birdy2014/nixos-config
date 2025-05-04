{ lib, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sun *-*-1..7 02:00";
    };

    autoSnapshot = {
      enable = true;
      frequent = 0;
      hourly = 8;
      daily = 7;
      weekly = 4;
      monthly = 0;
    };
  };

  systemd.timers = {
    "zfs-snapshot-frequent".enable = false;
    "zfs-snapshot-hourly".enable = false;
    "zfs-snapshot-daily".timerConfig.OnCalendar = lib.mkForce "*-*-* 02:00:00";
    "zfs-snapshot-weekly".timerConfig.OnCalendar =
      lib.mkForce "Mon *-*-* 02:00:00";
    "zfs-snapshot-monthly".enable = false;
  };

  # zpool has `mountpoint=legacy`
  fileSystems = {
    "/zpool/backup" = {
      device = "zpool/backup";
      fsType = "zfs";
    };

    "/zpool/encrypted/media" = {
      device = "zpool/encrypted/media";
      fsType = "zfs";
      # neededForBoot is necessary for encrypted datasets for the password prompt
      # to show up in initrd.
      neededForBoot = true;
    };

    "/zpool/encrypted/shares" = {
      device = "zpool/encrypted/shares";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/zpool/encrypted/immich" = {
      device = "zpool/encrypted/immich";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  services.zfs.zed.settings = {
    ZED_EMAIL_ADDR = [ "moritzv7+monitoring@gmail.com" ];
    ZED_EMAIL_PROG = "sendmail";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;
  };
}
