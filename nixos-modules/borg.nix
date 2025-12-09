{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Borgbackup sometimes fails without delay
  systemd.timers =
    lib.attrNames config.services.borgbackup.jobs
    |> map (name: "borgbackup-job-${name}")
    |> lib.flip lib.genAttrs (_: {
      timerConfig.RandomizedDelaySec = "10min";
    });

  systemd.services =
    lib.attrNames config.services.borgbackup.jobs
    |> map (name: "borgbackup-job-${name}")
    |> lib.flip lib.genAttrs (_: {
      onFailure = [ "notify-failure@%N.service" ];
      startLimitBurst = 3;
      startLimitIntervalSec = 300;
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
        TimeoutStartSec = "1min";
        Restart = "on-failure";
        RestartSec = "30";
      };
    });
}
