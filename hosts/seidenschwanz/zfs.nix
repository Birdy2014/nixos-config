{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sun *-*-1..7 01:00";
      randomizedDelaySec = "2h";
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
    "zfs-snapshot-weekly".timerConfig.OnCalendar = lib.mkForce "Mon *-*-* 02:00:00";
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
    ZED_NTFY_URL = "https://ntfy.mvogel.dev";
    ZED_NTFY_TOPIC = "monitoring";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;
  };

  environment.etc."zfs/zed.d/zed.rc" = {
    text = lib.mkForce null;
    source = config.sops.templates.zed-config.path;
  };

  sops.templates."zed-config".content = ''
    ZED_NTFY_ACCESS_TOKEN="${config.sops.placeholder.ntfy-sender-token}"
  ''
  + (lib.concatMapAttrsStringSep "\n" (
    name: value:
    name
    + "="
    + (
      if lib.isInt value then
        toString value
      else if lib.isString value then
        "\"${value}\""
      else if true == value then
        "1"
      else if false == value then
        "0"
      else
        lib.err "this value is" (toString value)
    )
  ) config.services.zfs.zed.settings);
}
