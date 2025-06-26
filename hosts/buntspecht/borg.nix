{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.borgbackup.jobs.data =
    let
      # This directory must exist and be owned by postgres:postgres
      dbBackupDir = "/var/backup/postgresqldump";
      pg_dump = lib.getExe' pkgs.postgresql "pg_dump";
    in
    {
      user = "root";
      group = "root";
      paths = [
        "/etc/nixos"
        "/etc/nixos-secrets"
        "/root/wireguard"
        "/var/db/bind"
        "/var/lib/matrix-synapse"
        "/var/lib/nextcloud"
        "/var/lib/private/improtheater-frankfurt"
        dbBackupDir
      ];
      compression = "zstd,10";
      repo = "borg@seidenschwanz.mvogel.dev:.";
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i ${config.sops.secrets.borgbackup-data-key.path}";
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
            "matrix-synapse"
            "nextcloud"
          ];
    };
}
