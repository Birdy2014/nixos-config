{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.borgbackup.jobs.seidenschwanz-services =
    let
      # This directory must exist and be owned by postgres:postgres
      dbBackupDir = "/var/backup/postgresqldump";
      pg_dump = lib.getExe' config.services.postgresql.finalPackage "pg_dump";
    in
    {
      user = "root";
      group = "root";
      paths = [
        "/etc/ssh"
        "/root/wireguard"
        "/var/lib/authelia-main"
        "/var/lib/bitwarden_rs"
        "/var/lib/jellyfin"
        "/var/lib/paperless"
        "/var/lib/syncthing"
        "/var/lib/private/einkaufszettel"
        "/var/lib/private/lldap"
        "/var/lib/private/mealie"
        dbBackupDir
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
      readWritePaths = [ dbBackupDir ];
      preHook =
        lib.concatMapStringsSep "\n"
          (dbName: "${lib.getExe pkgs.sudo} -u postgres ${pg_dump} -f ${dbBackupDir}/${dbName} ${dbName}")
          [
            "immich"
          ];
    };
}
