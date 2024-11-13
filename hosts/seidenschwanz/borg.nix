{ ... }:

{
  services.borgbackup.jobs.var_lib = let base = "/var/lib";
  in {
    user = "root";
    group = "root";
    paths = [
      "${base}/authelia-main"
      "${base}/jellyfin"
      "${base}/paperless"
      "${base}/private/lldap"
      "${base}/private/mealie"
    ];
    exclude = [ "${base}/jellyfin/transcodes" ];
    compression = "zstd,10";
    repo = "/zpool/backup/var_lib";
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
