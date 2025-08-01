{ config, ... }:

{
  services.borgbackup.jobs.home =
    let
      home = "/home/moritz";
    in
    {
      user = "moritz";
      group = "users";
      paths = [
        "${home}/.config"
        "${home}/.local"
        "${home}/.mozilla"
        "${home}/.ssh"
        "${home}/.thunderbird"
        "${home}/Downloads"
        "${home}/misc"
      ];
      exclude = [
        "${home}/.local/share/containers"
        "${home}/.local/share/Trash"
      ];
      compression = "zstd,1";
      repo = "borg@seidenschwanz.mvogel.dev:.";
      environment.BORG_RSH = "ssh -i ${config.sops.secrets.borgbackup-home-key.path}";
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
