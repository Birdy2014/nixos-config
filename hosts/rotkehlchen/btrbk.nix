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
  }
  // (builtins.listToAttrs (
    map
      (mountpoint: {
        name = baseNameOf mountpoint;
        value = {
          settings = {
            snapshot_preserve = "7d 8h";
            snapshot_preserve_min = "2h";
            snapshot_dir = "${mountpoint}/snapshots";
            subvolume."${mountpoint}" = { };
          };
          onCalendar = "hourly";
        };
      })
      [
        "/run/media/moritz/archive"
        "/run/media/moritz/games"
      ]
  ));
}
