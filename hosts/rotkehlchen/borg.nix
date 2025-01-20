{ config, ... }:

{
  services.borgbackup.jobs.home = let home = "/home/moritz";
  in {
    user = "moritz";
    group = "users";
    paths = [
      "${home}/.config"
      "${home}/.local"
      "${home}/.mozilla"
      "${home}/.sandboxed"
      "${home}/.ssh"
      "${home}/.thunderbird"
      "${home}/Documents"
      "${home}/Downloads"
      "${home}/Music"
      "${home}/Pictures"
      "${home}/misc"
      "${home}/src"
      "/etc/nixos"
      "/etc/nixos-secrets"
    ];
    exclude = [ "${home}/.local/share/containers" ];
    compression = "zstd,10";
    repo = "borg@seidenschwanz.mvogel.dev:.";
    environment.BORG_RSH =
      "ssh -i ${config.sops.secrets.borgbackup-home-key.path}";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.sops.secrets.borgbackup-home-password.path}";
    };
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
