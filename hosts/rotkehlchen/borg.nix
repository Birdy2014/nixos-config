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
      "${home}/.ssh"
      "${home}/.thunderbird"
      "${home}/Downloads"
      "${home}/misc"
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
  };
}
