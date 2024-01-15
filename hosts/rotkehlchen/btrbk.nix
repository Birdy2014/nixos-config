{ ... }:

{
  services.btrbk.instances = {
    root = {
      settings = {
        snapshot_preserve = "14d 4h";
        snapshot_preserve_min = "2h";
        snapshot_dir = "/snapshots";
        subvolume."/" = { };
        subvolume."/home" = { };
      };
      onCalendar = "hourly";
    };
  } // (builtins.listToAttrs (map (mountpoint: {
    name = baseNameOf mountpoint;
    value = {
      settings = {
        snapshot_preserve = "14d 4h";
        snapshot_preserve_min = "2h";
        snapshot_dir = "${mountpoint}/snapshots";
        subvolume."${mountpoint}" = { };
      };
      onCalendar = "hourly";
    };
  }) [
    "/run/media/moritz/archive"
    "/run/media/moritz/archive2"
    "/run/media/moritz/games"
  ]));
}
