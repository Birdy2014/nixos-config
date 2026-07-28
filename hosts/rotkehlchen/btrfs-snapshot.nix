{ ... }:

{
  my.btrfs-snapshot = {
    enable = true;
    settings = [
      {
        base_path = "/";
        snapshot_path = "/snapshots";
      }
      {
        base_path = "/home";
        snapshot_path = "/snapshots";
      }
      {
        base_path = "/run/media/moritz/archive";
        snapshot_path = "/run/media/moritz/snapshots";
      }
      {
        base_path = "/run/media/moritz/games";
        snapshot_path = "/run/media/moritz/snapshots";
      }
    ];
  };
}
