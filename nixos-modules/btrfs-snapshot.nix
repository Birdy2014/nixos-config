{
  config,
  lib,
  pkgs,
  pkgsSelf,
  ...
}:

let
  cfg = config.my.btrfs-snapshot;
in
{
  options.my.btrfs-snapshot = {
    enable = lib.mkEnableOption "automatic btrfs snapshots";

    settings = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            base_path = lib.mkOption {
              type = lib.types.str;
              description = "Path to btrfs subvolume to snapshots";
            };

            snapshot_path = lib.mkOption {
              type = lib.types.str;
              description = "Snapshot directory";
            };

            preserve_hourly = lib.mkOption {
              type = lib.types.int;
              default = 12;
              description = "Amount of hourly snapshots to keep";
            };
            preserve_daily = lib.mkOption {
              type = lib.types.int;
              default = 14;
              description = "Amount of daily snapshots to keep";
            };
            preserve_min_hours = lib.mkOption {
              type = lib.types.int;
              default = 4;
              description = "Minimal amount of hours to preserve all snapshots";
            };
          };
        }
      );
      default = [ ];
      description = "";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.btrfs-snapshot = {
      environment.CONFIG = pkgs.writers.writeJSON "btrfs-snapshot-config.json" cfg.settings;
      serviceConfig.ExecStart = lib.getExe pkgsSelf.btrfs-snapshot;
    };

    systemd.timers.btrfs-snapshot = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "*-*-* *:00:00";
    };
  };
}
