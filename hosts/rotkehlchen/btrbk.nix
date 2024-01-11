{ ... }:

{
  services.btrbk.instances = {
    root.settings = {
      snapshot_preserve = "14d";
      snapshot_preserve_min = "2d";
      snapshot_dir = "/snapshots";
      subvolume."/" = { };
      subvolume."/home" = { };
    };

    archive.settings = let mountpoint = "/run/media/moritz/archive";
    in {
      snapshot_preserve = "14d";
      snapshot_preserve_min = "2d";
      snapshot_dir = "${mountpoint}/snapshots";
      subvolume."${mountpoint}" = { };
    };

    archive2.settings = let mountpoint = "/run/media/moritz/archive2";
    in {
      snapshot_preserve = "14d";
      snapshot_preserve_min = "2d";
      snapshot_dir = "${mountpoint}/snapshots";
      subvolume."${mountpoint}" = { };
    };

    games.settings = let mountpoint = "/run/media/moritz/games";
    in {
      snapshot_preserve = "14d";
      snapshot_preserve_min = "2d";
      snapshot_dir = "${mountpoint}/snapshots";
      subvolume."${mountpoint}" = { };
    };
  };
}
