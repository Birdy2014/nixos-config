{ config, ... }:

{
  services.borgbackup.jobs.data = {
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
  };
}
