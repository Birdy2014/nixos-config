{ ... }:

{
  services.btrbk.instances.root = {
    onCalendar = "hourly";
    settings = {
      snapshot_preserve = "7d 8h";
      snapshot_preserve_min = "2h";
      snapshot_dir = "/snapshots";
      subvolume."/" = { };
    };
  };
}
