{ pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zpool" ];
  environment.systemPackages = with pkgs; [ zfs ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sat *-*-1..7 20:00";
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

  systemd.timers."zfs-snapshot-frequent".enable = false;
  systemd.timers."zfs-snapshot-hourly".enable = false;
  systemd.timers."zfs-snapshot-daily".enable = true;
  systemd.timers."zfs-snapshot-weekly".enable = true;
  systemd.timers."zfs-snapshot-monthly".enable = false;
}
