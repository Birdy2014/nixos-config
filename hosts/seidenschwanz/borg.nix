{ ... }:

{
  services.borgbackup.jobs.seidenschwanz-services = {
    user = "root";
    group = "root";
    paths = [
      "/etc/ssh"
      "/var/lib/authelia-main"
      "/var/lib/jellyfin"
      "/var/lib/paperless"
      "/var/lib/private/lldap"
      "/var/lib/private/mealie"
    ];
    exclude = [ "/var/lib/jellyfin/transcodes" ];
    compression = "zstd,10";
    repo = "/zpool/backup/seidenschwanz-services";
    encryption.mode = "none";
    startAt = "*-*-* 00:00:00";
    persistentTimer = true;
    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };
}
