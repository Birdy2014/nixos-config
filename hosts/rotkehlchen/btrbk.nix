{ ... }:

{
  services.btrbk.instances.home.settings = {
    snapshot_preserve = "14d";
    snapshot_preserve_min = "2d";
    snapshot_dir = "/snapshots";
    subvolume."/home" = { };
  };
}
