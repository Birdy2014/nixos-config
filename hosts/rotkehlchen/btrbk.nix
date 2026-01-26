{ ... }:

{
  services.btrbk.instances = {
    root = {
      settings = {
        snapshot_preserve = "7d 8h";
        snapshot_preserve_min = "2h";
        snapshot_dir = "/snapshots";
        subvolume."/" = { };
        subvolume."/home" = { };
      };
      onCalendar = "hourly";
    };

    archive = {
      settings = {
        snapshot_preserve = "7d 8h";
        snapshot_preserve_min = "2h";
        snapshot_dir = "/run/media/moritz/snapshots";
        subvolume."/run/media/moritz/archive" = { };
        subvolume."/run/media/moritz/games" = { };
      };
      onCalendar = "hourly";
    };
  };
}
