{ config, lib, pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sun *-*-1..7 02:00";
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

  systemd.timers = {
    "zfs-snapshot-frequent".enable = false;
    "zfs-snapshot-hourly".enable = false;
    "zfs-snapshot-daily".timerConfig.OnCalendar = lib.mkForce "*-*-* 02:00:00";
    "zfs-snapshot-weekly".timerConfig.OnCalendar =
      lib.mkForce "Mon *-*-* 02:00:00";
    "zfs-snapshot-monthly".enable = false;
  };

  # zpool has `mountpoint=legacy`
  fileSystems = {
    "/zpool/backup" = {
      device = "zpool/backup";
      fsType = "zfs";
    };

    "/zpool/encrypted/media" = {
      device = "zpool/encrypted/media";
      fsType = "zfs";
      # neededForBoot is necessary for encrypted datasets for the password prompt
      # to show up in initrd.
      neededForBoot = true;
    };

    "/zpool/encrypted/shares" = {
      device = "zpool/encrypted/shares";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/zpool/encrypted/immich" = {
      device = "zpool/encrypted/immich";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  services.zfs.zed.settings = let
    # The email subject has to be translated into a sendmail-style format
    zedMail = pkgs.writers.writePython3 "zed-mail.py" {
      flakeIgnore = [ "E111" "E501" "E121" ];
    } # python
      ''
        import sys
        import subprocess

        message: list[str] = []
        email_subject: str = ""
        email_from = "${config.services.nullmailer.config.allmailfrom}"
        email_to = "${config.services.nullmailer.config.adminaddr}"

        for line in sys.stdin:
          message.append(line)

        is_subject = False
        for arg in sys.argv[1:]:
          if is_subject:
            email_subject = arg
            is_subject = False
            continue

          if arg == "-s":
            is_subject = True
            continue

        envelope_head = [
          f"From: {email_from}",
          f"To: {email_to}",
          f"Subject: {email_subject}",
        ]

        sendmail_message = "\r\n".join(envelope_head) + "\r\n\r\n" + "\r\n".join(message)

        process = subprocess.Popen(["/run/wrappers/bin/sendmail", "-v", email_to], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
        out, err = process.communicate(input=sendmail_message)
        code = process.returncode
        print(out)
        print(err, file=sys.stderr)
        exit(code)
      '';
  in {
    ZED_EMAIL_ADDR = [ config.services.nullmailer.config.adminaddr ];
    ZED_EMAIL_PROG = "${zedMail}";
    ZED_EMAIL_OPTS = "-s @SUBJECT@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;
  };
}
